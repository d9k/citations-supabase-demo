import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { useNavigate } from 'react-router-dom';
import { usePageFrameLayoutContext } from '/~/shared/providers/layout/page-frame.tsx';

const LogoutPage = () => {
  const { PageFrameComponent } = usePageFrameLayoutContext();

  // const [loading, setLoading] = useState(false);
  const supabase = useSupabase();
  const navigate = useNavigate();

  supabase?.auth?.signOut().then(() => {
    navigate('/');
  });

  return (
    <PageFrameComponent>
      <h3>Logging out...</h3>
      <Spinner />;
    </PageFrameComponent>
  );
};

export default LogoutPage;
