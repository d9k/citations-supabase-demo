import { useSupabase } from '/~/shared/providers/supabase/client.ts';
import { OtpForm, OtpFormValues } from '/~/features/auth/OtpForm.tsx';
import { useCallback } from 'react';
import { useState } from 'react';
import { usePageFrameLayoutComponent } from '/~/shared/providers/layout/page-frame/index.tsx';

const LoginPage = () => {
  const PageFrameComponent = usePageFrameLayoutComponent();

  const [loading, setLoading] = useState(false);
  const supabase = useSupabase();

  const handleLogin = useCallback(async ({ email }: OtpFormValues) => {
    // event.preventDefault()

    setLoading(true);

    if (!supabase) {
      throw Error('Supabase not defined');
    }

    const { error } = await supabase.auth.signInWithOtp({ email });

    if (error) {
      alert(error.message || error.cause);
      // || (error as any).error_description
    } else {
      alert('Check your email for the login link!');
    }
    setLoading(false);
  }, []);

  return (
    <PageFrameComponent>
      <OtpForm onOtpLogin={handleLogin} loading={loading} />
    </PageFrameComponent>
  );
};

export default LoginPage;
