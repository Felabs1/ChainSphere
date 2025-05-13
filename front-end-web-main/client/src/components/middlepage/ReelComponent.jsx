import React, { useEffect, useState } from "react";
import styles from "./ReelComponent.module.css";
import video from "../../assets/nature.mp4";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faMessage,
  faThumbsUp,
  faThumbsDown,
  faShare,
  faPause,
  faPlay,
  faVolumeHigh,
  faArrowRotateBack,
  faCameraAlt,
  faMusic,
  faHeart,
} from "@fortawesome/free-solid-svg-icons";
import Video from "./video_essentials/Video";

import { bigintToLongAddress } from "../../utils/AppUtils";

const ReelComponent = () => {
  const [loading, setLoading] = useState(false);
  const [reels, setReels] = useState([]);

  const view_reels = () => {};

  return (
    <div className={styles.body}>
      <div className={styles.app__videos} id="video-container">
        {reels &&
          reels.map((reel, id) => {
            return (
              <Video
                key={id}
                video={reel.video}
                description={reel.description}
                caller={bigintToLongAddress(reel.caller)}
                comments={reel.comments.toString()}
                dislikes={reel.dislikes.toString()}
                likes={reel.likes.toString()}
                reel_id={reel.reel_id.toString()}
                shares={reel.shares.toString()}
                zuri_points={reel.zuri_points.toString()}
                view_reel={view_reels}
              />
            );
          })}
      </div>
    </div>
  );
};

export default ReelComponent;
