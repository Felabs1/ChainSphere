import React, { useEffect, useState } from "react";
import styles from "./CommentContainer.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCommentDots, faSmile } from "@fortawesome/free-solid-svg-icons";
import { bigintToShortStr } from "../../utils/AppUtils";

const CommentContainer = ({
  containsThread,
  username,
  userAddress,
  time_commented,
  profilePic,
  content,
  likes,
  postId,
  replies = [],
}) => {
  const [user, setUser] = useState({});
  const [loading, setLoading] = useState(false);
  const [replyText, setReplyText] = useState("");
  const [replyList, setReplyList] = useState(replies);
  const [showReplyInput, setShowReplyInput] = useState(false);

  return (
    <div className={styles.comment_container}>
      {user && (
        <div className={styles.comment_header}>
          <div className={styles.commenter_profile_and_name}>
            <div
              className={styles.commenter_profile}
              style={{ backgroundImage: `url(${user.profile_pic})` }}
            ></div>
            <div className={styles.commenter_name}>
              <span>{bigintToShortStr(user.username)}</span>
              <span className={styles.duration}>{time_commented}</span>
            </div>
          </div>
          <FontAwesomeIcon icon={faCommentDots} />
        </div>
      )}

      <div className={styles.comment_body}>
        <p>{content}</p>
      </div>

      <div className={styles.comment_footer}>
        <button className={styles.react_button}>
          {likes && likes.toString()}
          <FontAwesomeIcon icon={faSmile} />
        </button>
        <button
          className={styles.reply_button}
          onClick={() => setShowReplyInput(!showReplyInput)}
        >
          Reply
        </button>
      </div>

      {showReplyInput && (
        <div>
          <input
            type="text"
            className={styles.reply_input}
            placeholder="Write a reply..."
            value={replyText}
            onChange={(e) => setReplyText(e.target.value)}
          />
          <button className={styles.reply_button} onClick={handleReplySubmit}>
            Submit
          </button>
        </div>
      )}

      {replyList.length > 0 && (
        <div className={styles.replies_section}>
          {replyList.map((reply, index) => (
            <CommentContainer
              key={index}
              username={reply.username}
              time_commented={reply.time_commented}
              content={reply.content}
              profilePic={profilePic}
              likes={0}
              containsThread={false}
            />
          ))}
        </div>
      )}
    </div>
  );
};

export default CommentContainer;
