import React, {useState} from 'react'
import HeroPage from '../Components/Landing/HeroPage'
import LandingProblem from '../Components/Landing/LandingProblem'
import LandingSolution from '../Components/Landing/LandingSolution'
import FinalCTA from '../Components/Landing/FinalCTA'
import Footer from '../Components/Landing/LandingFooter'
import '../styles/LandingPageStyles.css'
import LandingPageNavbar from '../Components/Landing/LandingPageNavbar'

const LandingPage = () => {
  const [menuOpen, setMenuOpen] = useState(false);
  return (
    <div className="landingPage-container">
      <div className="myNavbar">
        <LandingPageNavbar menuOpen={menuOpen} setMenuOpen={setMenuOpen} />
      </div>
      <div className="content" onClick={() => setMenuOpen(false)}>
        <HeroPage />
        <LandingProblem />
        <LandingSolution />
        <FinalCTA />
        <Footer />
      </div>
    </div>
  );
}

export default LandingPage