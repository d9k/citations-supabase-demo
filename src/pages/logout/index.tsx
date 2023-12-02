import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { useNavigate } from 'react-router-dom';

const LogoutPage = () => {
  // const [loading, setLoading] = useState(false);
  const supabase = useSupabase();
  const navigate = useNavigate();

  supabase?.auth?.signOut().then(() => {
    navigate('/');
  });

  return (
    <>
      <h3>Logging out...</h3>
      <Spinner />;
    </>
  );
};

export default LogoutPage;
