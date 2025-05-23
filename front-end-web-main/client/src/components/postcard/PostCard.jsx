import React, { useRef, useState } from "react";
import styles from "./PostCard.module.css"; // Import CSS module
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { BeatLoader } from "react-spinners";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { TransactionButton,useSendAndConfirmTransaction } from "thirdweb/react";
import {
  faImage,
  faVideo,
  faChartBar,
  faGlobe,
  faBucket,
  faSmile,
  faXmark,
} from "@fortawesome/free-solid-svg-icons";
import { createPost } from "../../contract_interactions/PostManagement";
import { uploadToIPFS } from "../../Infura";
import { multilineToSingleline } from "../../utils/AppUtils";
import dp from "../../assets/chainsphere.png";
import { IncrementButton } from "../../contract_interactions/PostManagement";
import { useAccount } from "wagmi";

const PostCard = () => {


  const fileInputRef = useRef(null);
  const postContent = useRef();
  const [fileURLs, setFileURLs] = useState([]);
  const [loading, setLoading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
   const { mutateAsync: sendTx } = useSendAndConfirmTransaction();
   const { address, isConnecting, isDisconnected } = useAccount();

  const handleFileClick = () => {
    fileInputRef.current.click();
  };

  const handleRemoveFile = (indexToRemove) => {
    setFileURLs(fileURLs.filter((_, index) => index !== indexToRemove));
  };

  const handleSubmitForm = () => {};

  const handleFileUpload = async (e) => {
    const selectedFiles = e.target.files;
    if (!selectedFiles.length) return;

    setLoading(true);
    const uploadedUrls = [];

    try {
      let totalProgress = 0;

      for (let i = 0; i < selectedFiles.length; i++) {
        const file = selectedFiles[i];
        const response = await uploadToIPFS(file);
        uploadedUrls.push(response);

        // Update progress
        totalProgress = Math.round(((i + 1) / selectedFiles.length) * 100);
        setUploadProgress(totalProgress);
      }

      setFileURLs([...fileURLs, ...uploadedUrls]);
      toast.success(`${uploadedUrls.length} file(s) uploaded successfully`, {
        className: styles.modern_toast,
      });
    } catch (error) {
      console.error("Error uploading files:", error);
      toast.error("Failed to upload files", {
        className: styles.modern_toast,
      });
    } finally {
      setLoading(false);
      setUploadProgress(0);
    }
  };

  const post = () =>{
    try {
      return sendTx(createPost("hello", "fileURLs.toString()"))
    }catch(e){
      console.log(e)
    }
  }

  return (
    <div className={styles.postCard}>
      <ToastContainer position="top-right" autoClose={3000} />

      <div className={styles.postHeader}>
        <div className={styles.userAvatar}>
          <img src={dp} alt="User" />
        </div>
        <div className={styles.postInputContainer}>
          <textarea
            ref={postContent}
            placeholder="What's on your mind?"
            className={styles.postTextarea}
          />
        </div>
      </div>

      {uploadProgress > 0 && (
        <div className={styles.uploadProgress}>
          <div
            className={styles.progressBar}
            style={{ width: `${uploadProgress}%` }}
          >
            <span className={styles.progressText}>{uploadProgress}%</span>
          </div>
        </div>
      )}

      {fileURLs.length > 0 && (
        <div className={styles.filePreview}>
          {fileURLs.map((file, index) => (
            <div key={index} className={styles.fileTag}>
              <span className={styles.fileName}>
                {file.substring(0, 5)}...{file.substring(file.length - 5)}
              </span>
              <button
                className={styles.removeFile}
                onClick={() => handleRemoveFile(index)}
              >
                <FontAwesomeIcon icon={faXmark} />
              </button>
            </div>
          ))}
        </div>
      )}

      <div className={styles.cardActions}>
        <div className={styles.actionButtons}>
          <button className={styles.actionBtn} onClick={handleFileClick}>
            <FontAwesomeIcon icon={faImage} />
            <span>Photo</span>
          </button>
          <button className={styles.actionBtn} onClick={handleFileClick}>
            <FontAwesomeIcon icon={faVideo} />
            <span>Video</span>
          </button>
          <button className={styles.actionBtn}>
            <FontAwesomeIcon icon={faSmile} />
            <span>Feeling</span>
          </button>
          <button className={styles.actionBtn}>
            <FontAwesomeIcon icon={faChartBar} />
            <span>Poll</span>
          </button>
          <button className={styles.actionBtn}>
            <FontAwesomeIcon icon={faGlobe} />
            <span>Location</span>
          </button>
        </div>

        {/* <button
          className={`${styles.postButton} ${loading ? styles.loading : ""}`}
          onClick={async () => await sendTx(createPost("hello", "fileURLs.toString()"))}
          disabled={loading}
        >
          {loading ? (
            <BeatLoader loading={loading} color="#fff" size={8} />
          ) : (
            "Post Now"
          )}
        </button> */}
      <TransactionButton transaction={() => createPost(postContent.current.value, fileURLs.toString())}>Post Now</TransactionButton>
    
      </div>
      <input
        type="file"
        ref={fileInputRef}
        onChange={handleFileUpload}
        accept="image/*,video/*"
        multiple
        style={{ display: "none" }}
      />
    </div>
  );
};

export default PostCard;
