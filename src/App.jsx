import { Routes, Route } from "react-router-dom";
import NavBar from "./components/NavBar.jsx";
import About from "./pages/About.jsx";
import Skills from "./pages/Skills.jsx";
import Projects from "./pages/Projects.jsx";
import Links from "./pages/Links.jsx";
import TrackerDashboard from "./tracker/TrackerDashboard.jsx";
import ProblemList from "./tracker/ProblemList.jsx";
import ProblemForm from "./tracker/ProblemForm.jsx";
import ProblemDetail from "./tracker/ProblemDetail.jsx";

export default function App() {
  return (
    <div className="min-h-screen bg-paper font-body text-ink">
      <NavBar />
      <Routes>
        <Route path="/" element={<About />} />
        <Route path="/skills" element={<Skills />} />
        <Route path="/projects" element={<Projects />} />
        <Route path="/links" element={<Links />} />
        <Route path="/tracker" element={<TrackerDashboard />} />
        <Route path="/tracker/problems" element={<ProblemList />} />
        <Route path="/tracker/new" element={<ProblemForm />} />
        <Route path="/tracker/problems/:id" element={<ProblemDetail />} />
        <Route path="/tracker/problems/:id/edit" element={<ProblemForm />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </div>
  );
}

function NotFound() {
  return (
    <div className="mx-auto max-w-5xl px-6 py-20 text-center">
      <p className="font-display text-2xl font-semibold text-ink">404</p>
      <p className="mt-2 text-slate">That page doesn't exist.</p>
    </div>
  );
}
