import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';
import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame.tsx';
import { JsonView } from '/~/shared/ui/json-view.tsx';

const ProfilePage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();
  // const [loading, setLoading] = useState(false);
  const user = useSupabaseUser();

  return (
    <PageFrameComponent>
      <h3>Profile</h3>
      <JsonView data={user} />
    </PageFrameComponent>
  );
};

export default ProfilePage;
