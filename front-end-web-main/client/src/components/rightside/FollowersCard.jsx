import React, { useEffect, useState } from "react";
import styles from "./FollowersCard.module.css";

import FollowersLIst from "./FollowersLIst";
import { bigintToLongAddress, bigintToShortStr } from "../../utils/AppUtils";
import { ClipLoader } from "react-spinners";
import { useNavigate } from "react-router-dom";
import { userData } from "../../utils/constants";

const FollowersCard = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    setUsers(userData);
  }, []);

  return (
    <div className={styles.followers_card}>
      <div className={styles.followers_card_header}>
        <div className={styles.left_heading}>you will like</div>
        <div className={styles.right_heading}>view all</div>
      </div>
      <br />
      {loading ? (
        <div className="w3-center">
          <ClipLoader loading={loading} color="#2196F3" size={50} />
        </div>
      ) : (
        users &&
        users.map((user, id) => {
          return (
            <FollowersLIst
              key={id}
              userAddress={bigintToLongAddress(user.userId)}
              profileImage={user.profile_pic}
              username={bigintToShortStr(user.username)}
              followText="follow"
              onNavigate={() => {
                navigate(`/profile/${bigintToLongAddress(user.userId)}`);
              }}
            />
          );
        })
      )}

      {/* <FollowersLIst
        profileImage={profile1}
        username="james"
        followText="follow"
      />
      <FollowersLIst
        profileImage={profile2}
        username="charles"
        followText="follow back"
      />
      <FollowersLIst
        profileImage={profile3}
        username="jack"
        followText="follow"
      />
      <FollowersLIst
        profileImage={profile2}
        username="erick"
        followText="follow back"
      /> */}
    </div>
  );
};

export default FollowersCard;
