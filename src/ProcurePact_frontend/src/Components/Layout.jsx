import "../styles/LayoutStyles.css";
import MainNavbar from "./MainNavbar";
import { Outlet } from "react-router-dom";
import MainSideNavbar from "./MainSideNavbar";
import ProcureChat from "./ProcureChat/ProcureChat";
import { useAuth } from "../Hooks/AuthContext";
import PleaseLogin from "./PleaseLogin";
import MainIconNavbar from "./MainIconNavbar";
import MainHarmburgerNavbar from "./MainHarmbugerNavbar";


const Layout = () => {
  const { user, isAuthenticated, setUser, principal } = useAuth();
  return (
    <div className="layout-container">
      <div className="navigation">
        {/* <MainNavbar /> */}
        <div className="full">
          <MainSideNavbar />
        </div>
        <div className="icons">
          <MainIconNavbar />
        </div>
        <div className="harmburger">
          <MainHarmburgerNavbar />
        </div>
      </div>

      <div className="main-content">
        {isAuthenticated ? (
          <>
            <Outlet />
            <ProcureChat />
          </>
        ) : (
          <PleaseLogin />
        )}
        {/* <Outlet />
        <ProcureChat /> */}
      </div>
    </div>
  );
};

export default Layout;









