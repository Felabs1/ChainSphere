import React, { useEffect, useState } from "react";
import styles from "./FollowersList.module.css";
import { bigintToLongAddress } from "../../utils/AppUtils";

const FollowersLIst = ({
  profileImage,
  username,
  followText,
  userAddress,
  onNavigate,
}) => {
  const [followers, setFollowers] = useState([]);
  const [follows, setFollows] = useState("follows");
  const [isFollowing, setIsFollowing] = useState(false);
  const [loading, setLoading] = useState(true);

  const followUser = () => {};

  // function followerExist() {
  //   // return arr.some((obj) => bigintToLongAddress(obj[property]) === value);
  //   const follows = followers.find(
  //     (user) => bigintToLongAddress(user.userId) === userAddress
  //   );
  //   console.log(follows);
  // }

  // console.log(isFollowing);

  return (
    <div className={styles.followers_list} onClick={onNavigate}>
      <div className={styles.followers_details}>
        <div
          className={styles.profile_image}
          style={{ backgroundImage: `url(${profileImage})` }}
        ></div>
        <div className={styles.profile_username}>{username}</div>
      </div>
      {/* {address && (
        <div className={styles.followers_button}>
          {follows == "followed" ? (
            <button className="w3-button" onClick={followUser}>
              follow back
            </button>
          ) : follows == "following" ? (
            "following"
          ) : (
            <button className="w3-button" onClick={followUser}>
              follow
            </button>
          )}
        </div>
      )} */}
    </div>
  );
};

export default FollowersLIst;
