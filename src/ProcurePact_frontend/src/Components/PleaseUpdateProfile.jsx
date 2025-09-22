import React from 'react'
import "../styles/PleaseUpdateProfile.css";

const PleaseUpdateProfile = () => {
  return (
    <div className="please-profile-container">
      <div className="please-profile-image">
        <img src="login2.png" alt="Please login" />
        {/* <img src="Sitted-girl-intro.png" alt="Dashboard intro" /> */}
      </div>
      <div className="please-profile-text">
        <p>Update Your Profile First</p>
      </div>
    </div>
  );
}

export default PleaseUpdateProfile