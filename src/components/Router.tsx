import { useCurrentPage } from '../hooks/useNavigate';
import App from '../App';
import LoginPage from '../pages/LoginPage';
import RegisterPage from '../pages/RegisterPage';
import ProtectedRoute from './ProtectedRoute';

export default function Router() {
  const currentPage = useCurrentPage();

  if (currentPage === '/login') {
    return <LoginPage />;
  }

  if (currentPage === '/register') {
    return <RegisterPage />;
  }

  return (
    <ProtectedRoute>
      <App />
    </ProtectedRoute>
  );
}
