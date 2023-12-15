import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';
import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import { Spinner } from '/~/shared/ui/spinner.tsx';
import { useNavigate } from 'react-router-dom';
import { json } from '/~/shared/lib/json.ts';
import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame.tsx';

const ProfilePage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();
  // const [loading, setLoading] = useState(false);
  const user = useSupabaseUser();

  return (
    <PageFrameComponent>
      <h3>Profile</h3>
      <pre>
        {json(user)}
      </pre>
    </PageFrameComponent>
  );
};

export default ProfilePage;
