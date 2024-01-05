import { useSupabaseUser } from '/~/shared/providers/supabase/user.ts';
import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame/index.tsx';
import { JsonView } from '/~/shared/ui/json-view.tsx';
import {
  profileCaptionFromUserName,
  userNameFromEmail,
} from '/~/shared/lib/user.ts';
import { PageTitle } from '/~/shared/ui/page-title.tsx';

const ProfilePage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();
  // const [loading, setLoading] = useState(false);
  const supabaseUser = useSupabaseUser();
  const email = supabaseUser?.email;
  const userName = userNameFromEmail(email);
  const profileCaption = profileCaptionFromUserName(userName);

  return (
    <PageFrameComponent>
      <PageTitle>{profileCaption}</PageTitle>
      <JsonView data={supabaseUser} />
    </PageFrameComponent>
  );
};

export default ProfilePage;
