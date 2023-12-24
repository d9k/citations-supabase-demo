import { useCallback, useEffect, useMemo, useState } from 'react';
import { upperFirst, useToggle } from '@mantine/hooks';
import { useForm } from '@mantine/form';
import {
  Anchor,
  Button,
  Checkbox,
  Divider,
  Group,
  Paper,
  PaperProps,
  PasswordInput,
  Space,
  Stack,
  Text,
  TextInput,
} from '@mantine/core';

export type OtpFormValues = {
  email: string;
};

export type OtpFormProps = PaperProps & {
  demoField?: boolean;
  initialValues?: Partial<OtpFormValues>;
  loading?: boolean;
  onOtpLogin: (values: OtpFormValues) => void;
  title?: string;
};

type UseFormParams = Parameters<typeof useForm<OtpFormValues>>;

/** Error "A component is changing an uncontrolled input to be controlled" if skip any field default value */
export const defaultLoginFormValues = (): OtpFormValues => ({
  email: '',
});

type UseFormParam1 = NonNullable<UseFormParams[0]>;
type UseFormParamValidate = NonNullable<UseFormParam1['validate']>;

// (Function: This provides no type safety because it represents all functions and classes)
// deno-lint-ignore ban-types
type UseFormParamValidateObject = Exclude<UseFormParamValidate, Function>;

type UseFormParamValidateObjectRequired = Required<UseFormParamValidateObject>;

/**
 * forked from
 * https://github.com/mantinedev/ui.mantine.dev/blob/6f9c568ee161ab3239b826af92dd48415e319cf8/lib/AuthenticationForm/AuthenticationForm.tsx
 */
export function OtpForm(
  {
    onOtpLogin,
    initialValues = {},
    loading,
    title = 'Login with email only',
    ...props
  }: OtpFormProps,
) {
  const mergedInitialValues: OtpFormValues = useMemo(() => (
    { ...defaultLoginFormValues(), ...initialValues }
  ), [initialValues]);

  const form = useForm({
    initialValues: mergedInitialValues,
  });

  const inputSize = 'lg';

  return (
    <Paper radius='md' p='xl' withBorder {...props}>
      <Text size='lg' fw={500}>
        {title}
      </Text>

      {
        /* <Group grow mb="md" mt="md">
        <Button size="xs" radius="md" variant="default">Google</Button>
        <Button size="xs" radius="md" variant="default">Twitter</Button>
      </Group> */
      }

      <Space h='md' />

      {/* <Divider label="Or continue with email" labelPosition="center" my="lg" /> */}

      {/* <form onSubmit={handleSubmit}> */}
      <form
        onSubmit={form.onSubmit((values: OtpFormValues) => {
          console.log('__TEST__ LoginForm: submit', values);
          onOtpLogin?.(values);
        })}
      >
        <Stack>
          <TextInput
            required
            size={inputSize}
            placeholder='email'
            radius='md'
            {...form.getInputProps('email')}
          />
        </Stack>

        <Stack mt='xl'>
          <div>
            Note: sometimes login link doesn't work. If it happens, try to
            resend link again.
          </div>
          <Group align='flex-end' justify='space-between'>
            <Button type='submit' radius='xl' loading={loading}>
              Send one-time password
            </Button>
          </Group>
        </Stack>
      </form>
    </Paper>
  );
}
