import { useState, useEffect } from 'react';

type Page = '/' | '/login' | '/register';

export function useNavigate() {
  return (page: Page) => {
    window.history.pushState({}, '', page);
    window.dispatchEvent(new PopStateEvent('popstate'));
  };
}

export function useCurrentPage(): Page {
  const [currentPage, setCurrentPage] = useState<Page>(
    (window.location.pathname as Page) || '/'
  );

  useEffect(() => {
    const handlePopState = () => {
      setCurrentPage((window.location.pathname as Page) || '/');
    };

    window.addEventListener('popstate', handlePopState);
    return () => window.removeEventListener('popstate', handlePopState);
  }, []);

  return currentPage;
}
