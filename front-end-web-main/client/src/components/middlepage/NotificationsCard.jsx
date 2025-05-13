import React, { useState, useEffect } from "react";
import styles from "./NotificationsCard.module.css";

import {
  bigintToShortStr,
  isWithinOneDay,
  timeAgo,
} from "../../utils/AppUtils";
import { BounceLoader, ClipLoader } from "react-spinners";
import { useNavigate } from "react-router-dom";

const NotificationsCard = () => {
  const [loading, setLoading] = useState(false);
  const [notifications, setNotifications] = useState(false);

  const [users, setUsers] = useState([]);
  const navigate = useNavigate();

  const handleNavigation = (e) => {
    console.log(e.target.value);
    const notification_type = e.target.value;
    console.log(notification_type);
  };

  return (
    <div className={`${styles.notifications_card}`}>
      <h3>Notifications</h3>
      {/* <div className={`w3-bar ${styles.notifications_bar}`}>
        <a>Unread</a>
        <a>read</a>
        <a>archieved</a>
      </div> */}
      <br />

      <div className={styles.sub_notification_header}>
        <div className={styles.day}>
          <span className={styles.today}>Today</span>&nbsp;
          <span className="w3-tag w3-dark-gray w3-round-large">
            {notifications &&
              notifications.filter((notification) =>
                isWithinOneDay(notification.timestamp.toString() * 1000)
              ).length}
          </span>
        </div>
        <div className={styles.option}>see all</div>
      </div>
      <br />
      {loading ? (
        <div className="w3-center">
          <ClipLoader loading={loading} color="#2196F3" size={50} />
        </div>
      ) : (
        notifications &&
        notifications.map((notification) => {
          let word = notification.notification_message.split(" ");
          let shiftedWord = word.shift();
          let newSentence = word.join(" ");
          let profilePhoto = users.find(
            (user) => user.userId == notification.caller
          );
          const notification_type = bigintToShortStr(
            notification.notification_type
          );
          const time_ago = timeAgo(notification.timestamp.toString() * 1000);
          console.log(notification_type);

          return (
            <div
              key={notification.id || notification.timestamp}
              className={styles.notification_content}
            >
              <div className={styles.profile}>
                <div className={styles.online}></div>
                <div
                  className={styles.profile_pic}
                  style={{
                    backgroundImage: `url(${
                      profilePhoto && profilePhoto.profile_pic
                    })`,
                  }}
                ></div>
              </div>
              <div className={styles.description}>
                <span>
                  <b>{bigintToShortStr(shiftedWord)}</b> {newSentence}
                </span>
                <br />
                <small>{time_ago}</small>
                <br />
                <br />
                {/* <button className={`${styles.ignore} w3-button`}>Ignore</button> */}

                {/* {notification_type == "like" ? (
                  <button
                    className={`${styles.respond} w3-button`}
                    onClick={handleNavigation}
                    value={notification}
                  >
                    view post
                  </button>
                ) : notification_type == "follow!" ? (
                  <button
                    className={`${styles.respond} w3-button`}
                    onClick={handleNavigation}
                    value={notification}
                  >
                    view_profile
                  </button>
                ) : notification_type == "comment" ? (
                  <button
                    className={`${styles.respond} w3-button`}
                    onClick={handleNavigation}
                    value={notification}
                  >
                    view post
                  </button>
                ) : notification_type == "repost" ? (
                  <button
                    className={`${styles.respond} w3-button`}
                    onClick={handleNavigation}
                    value={notification}
                  >
                    View Post
                  </button>
                ) : (
                  ""
                )} */}
              </div>
            </div>
          );
        })
      )}
    </div>
  );
};

export default NotificationsCard;
