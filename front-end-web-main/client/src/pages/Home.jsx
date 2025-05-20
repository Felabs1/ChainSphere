import React, { useCallback, useState, useEffect } from "react";
import Skeleton from "react-loading-skeleton";
import { ToastContainer, toast } from "react-toastify";
import InfiniteScroll from "react-infinite-scroll-component";
import "react-toastify/dist/ReactToastify.css";
import "react-loading-skeleton/dist/skeleton.css";
import { BounceLoader, ClipLoader } from "react-spinners";
import TopNav from "../components/navigation/TopNav";
import SideNav from "../components/navigation/SideNav";
import Main from "../components/middlepage/Main";
import PostCard from "../components/postcard/PostCard";
import SubNavigation from "../components/navigation/SubNavigation";
import Post from "../components/middlepage/Post";
import MobileSidenav from "../components/navigation/MobileSidenav";
import FloatingButton from "../components/navigation/FloatingButton";
import ProfileCard from "../components/rightside/ProfileCard";
import AssetsCard from "../components/rightside/AssetsCard";
import FollowersCard from "../components/rightside/FollowersCard";
import { postData, loggedInUser } from "../utils/constants";

import { useAccount } from "wagmi";

import {
  bigintToLongAddress,
  bigintToShortStr,
  formatDate,
  getUint256CalldataFromBN,
  parseInputAmountToUint256,
  timeAgo,
} from "../utils/AppUtils";
import usePaginationStore from "../stores/usePaginationStore";

// console.log(timeAgo(1721310913 * 1000));

const Home = () => {
  const [navOpen, setNavOpen] = useState(false);
  const [posts, setPosts] = useState([]);
  const [user, setUser] = useState(null);
  const [users, setUsers] = useState([]);
 const { address, isConnecting, isDisconnected } = useAccount();

  const {
    page,
    totalPages,
    hasError,
    loading,
    setLoading,
    setHasError,
    initializePagination,
    decrementPage,
  } = usePaginationStore();

  useEffect(() => {
    setUser(loggedInUser);
  }, []);
  // console.log(
  //   viewUser(
  //     "0x07e868e262d6d19c181706f5f66faf730d723ebf604ecd7f5aff409f94d33516"
  //   )
  // );

  const view_user = async () => {};

  // console.log(user);
  const trytransfer = () => {};

  const view_users = () => {};

  function getUserName(userId) {
    if (users) {
      const _user = users.find((element) => element.userId == userId);
      // console.log(_user);
      return _user;
    }
  }

  // console.log(users);

  // Initialize total pages and starting page

  // Fetch posts for current page
  const fetchPosts = async () => {};

  // Fetch initial posts when pagination is initialized

  // console.log(user);

  // console.log(contract);
  const handleMobileMenuClick = () => {
    setNavOpen(!navOpen);
    console.log("something is wrong");
    console.log(navOpen);
  };

  const handleButtonClick = () => {
    setLoading(true);
    // Simulate an API call
    setTimeout(() => {
      setLoading(false);
    }, 20000);
  };

  return (
    <>
      <ToastContainer />
      <TopNav onMobileMenuClick={handleMobileMenuClick} />
      <SideNav />

      {navOpen && <MobileSidenav />}

      <Main>
        <div className="w3-row-padding w3-stretch">
          <div className="w3-col l8">
            <PostCard />
            <br />
            <SubNavigation
              borderData={
                [
                  // { linkName: "following" },
                  // { linkName: "Hot" },
                  // { linkName: "New" },
                  // { linkName: "explore" },
                ]
              }
            />

            {/* {loading ? (
              <div className="w3-center">
                <ClipLoader loading={loading} color="#2196F3" size={50} />
              </div>
            ) : ( */}
            <div>
              <br />
              <div>
                <br />

                <div>
                  <br />
                  <>
                    {postData?.map(
                      ({
                        postId,
                        caller,
                        content,
                        likes,
                        comments,
                        shares,
                        images,
                        zuri_points,
                        date_posted,
                      }) => {
                        const account_address = bigintToLongAddress(caller);

                        {
                          /* if (!user) return null; */
                        }

                        return (
                          <Post
                            key={postId}
                            userAddress={account_address}
                            postId={postId.toString()}
                            images={images.split(" ")}
                            content={content}
                            username={`Starkzuri`}
                            comments={comments.toString()}
                            profile_pic={user?.profile_pic}
                            likes={likes.toString()}
                            shares={shares.toString()}
                            zuri_points={zuri_points.toString()}
                            time_posted={timeAgo(date_posted.toString() * 1000)}
                          />
                        );
                      }
                    )}
                  </>
                </div>
              </div>
            </div>
            {/* )} */}
          </div>

          <div className="w3-col l4 w3-hide-small">
            {user ? (
              <ProfileCard
                about={user.about}
                name={bigintToShortStr(user.name)}
                username={bigintToShortStr(user.username)}
                no_following={user.number_following.toString()}
                no_of_followers={user.no_of_followers.toString()}
                profile_pic={user.profile_pic}
                cover_phroto={user.cover_photo}
                zuri_points={user.zuri_points.toString()}
                date_registered={formatDate(
                  user.date_registered.toString() * 1000
                )}
              />
            ) : (
              ""
            )}
            <br />

            <AssetsCard />
            <br />
            <FollowersCard />
          </div>
        </div>
        <FloatingButton />
      </Main>
    </>
  );
};

export default Home;
