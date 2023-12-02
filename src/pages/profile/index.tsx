import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';
import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { useNavigate } from 'react-router-dom';
import { json } from '/~/shared/lib/json.ts';

const ProfilePage = () => {
  // const [loading, setLoading] = useState(false);
  const user = useSupabaseUser();

  return (
    <>
      <h3>Profile</h3>
      <pre>
        {json(user)}
      </pre>
    </>
  );
};

export default ProfilePage;
