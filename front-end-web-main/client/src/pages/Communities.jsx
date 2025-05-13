import React, { useState, useEffect } from "react";

import TopNav from "../components/navigation/TopNav";
import SideNav from "../components/navigation/SideNav";
import Main from "../components/middlepage/Main";
import MobileSidenav from "../components/navigation/MobileSidenav";
import ProfileCard from "../components/rightside/ProfileCard";
import AssetsCard from "../components/rightside/AssetsCard";
import FollowersCard from "../components/rightside/FollowersCard";
import ExploreHeader from "../components/middlepage/ExploreHeader";
import PostCard from "../components/postcard/PostCard";
import { bigintToShortStr, formatDate } from "../utils/AppUtils";
import { CONTRACT_ADDRESS } from "../providers/abi";
import { ToastContainer, toast } from "react-toastify";
import crystals from "../assets/crystals.jpg";
import CommunityPosts from "./community_essentials/community_tabs/CommunityPosts";
import CommunityPolls from "./community_essentials/community_tabs/CommunityPolls";
import CommunityEvents from "./community_essentials/community_tabs/CommunityEvents";
import CommunityLeaderboard from "./community_essentials/community_tabs/CommunityLeaderboard";
import { useParams } from "react-router-dom";

const Communities = () => {
  const tabs = [
    { name: "Posts", content: <CommunityPosts /> },
    // { name: "Polls", content: <CommunityPolls /> },
    // { name: "Events", content: <CommunityEvents /> },
    // { name: "Leaderboard", content: <CommunityLeaderboard /> },
  ];
  const [navOpen, setNavOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [user, setUser] = useState(null);
  const [communityMembers, setCommunityMembers] = useState(false);
  const [activeTab, setActiveTab] = useState(0);
  const { id } = useParams();

  const view_user = () => {};

  const joinCommunity = async () => {};

  const viewCommunityMembers = () => {};

  const handleMobileMenuClick = () => {
    setNavOpen(!navOpen);
    console.log("something is wrong");
    console.log(navOpen);
  };

  return (
    <div>
      <TopNav onMobileMenuClick={handleMobileMenuClick} />
      <SideNav />

      {navOpen && <MobileSidenav />}
      <Main>
        <div className="w3-row-padding w3-stretch">
          <div className="w3-col l8">
            <ExploreHeader
              paragraph="Core supporters of the product. we value your prescence"
              heading="Zuri Pioneers Community"
              datecreated="created December 2024"
            />
            <br />
            <br />
            <span>
              <b>{communityMembers && communityMembers.length}</b>
            </span>{" "}
            {communityMembers && communityMembers.length > 1
              ? "members"
              : "member"}{" "}
            &nbsp;
            <button
              onClick={joinCommunity}
              className={`w3-button w3-border w3-round-xlarge`}
            >
              Join Community
            </button>
            {tabs.map((tab, index) => {
              return (
                <>
                  &nbsp;
                  <button
                    key={index}
                    onClick={() => {
                      setActiveTab(index);
                      console.log(index);
                    }}
                    className={`w3-button w3-border w3-round-xlarge ${
                      activeTab === index ? "w3-border-blue" : ""
                    }`}
                  >
                    {tab.name}
                  </button>
                </>
              );
            })}
            &nbsp;
            <br />
            <br />
            <br />
            {/* {tabs[activeTab].content} */}
            <div className="w3-container"></div>
          </div>
          <div className="w3-col l4 w3-hide-small">
            {/* {address && user ? (
              <ProfileCard
                about={user.about ? user.about : ""}
                name={user.name ? bigintToShortStr(user.name) : ""}
                username={bigintToShortStr(user.username)}
                no_following={user.number_following.toString()}
                no_of_followers={user.no_of_followers.toString()}
                profile_pic={user.profile_pic}
                cover_photo={user.cover_photo}
                zuri_points={user.zuri_points.toString()}
                date_registered={formatDate(
                  user.date_registered.toString() * 1000
                )}
              />
            ) : (
              ""
            )} */}

            <br />
            <AssetsCard />
            <br />
            <FollowersCard />
          </div>
        </div>
      </Main>
    </div>
  );
};

export default Communities;
