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

export enum LoginFormType {
  login = 'login',
  register = 'register',
}

export type LoginValues = {
  loginOrEmail: string;
  password: string;
};

export type LoginFormProps = PaperProps & {
  demoField?: boolean;
  initialValues?: Partial<LoginValues>;
  onSwitchToRegister?: (newRegisterForm: boolean) => void;
  onLogin: (values: LoginValues) => void;
  title?: string;
};

type UseFormParams = Parameters<typeof useForm<LoginValues>>;

/** Error "A component is changing an uncontrolled input to be controlled" if skip any field default value */
export const defaultLoginFormValues = (): LoginValues => ({
  loginOrEmail: '',
  password: '',
});

type UseFormParam1 = NonNullable<UseFormParams[0]>;
type UseFormParamValidate = NonNullable<UseFormParam1['validate']>;
type UseFormParamValidateObject = Exclude<UseFormParamValidate, Function>;
type UseFormParamValidateObjectRequired = Required<UseFormParamValidateObject>;

/**
 * forked from
 * https://github.com/mantinedev/ui.mantine.dev/blob/6f9c568ee161ab3239b826af92dd48415e319cf8/lib/AuthenticationForm/AuthenticationForm.tsx
 */
export function LoginForm(
  {
    onLogin,
    onSwitchToRegister,
    initialValues = {},
    title = 'Login',
    ...props
  }: LoginFormProps,
) {
  const mergedInitialValues: LoginValues = useMemo(() => (
    { ...defaultLoginFormValues(), ...initialValues }
  ), [initialValues]);

  const form = useForm({
    initialValues: mergedInitialValues,
  });

  const inputSize = 'lg';

  // TODO почему, если запомнить, значения не меняются?!
  // const handleSubmit = useCallback(
  //   form.onSubmit(
  //     (values) => {
  //       console.log('__TEST__ LoginForm: submit', values);
  //     },
  //   ),
  //   [],
  // );

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
        onSubmit={form.onSubmit((values) => {
          console.log('__TEST__ LoginForm: submit', values);
          onLogin?.(values);
        })}
      >
        <Stack>
          <TextInput
            required
            size={inputSize}
            placeholder='Login or email'
            radius='md'
            {...form.getInputProps('loginOrEmail')}
          />

          <PasswordInput
            required
            size={inputSize}
            placeholder='Your password'
            radius='md'
            {...form.getInputProps('password')}
          />
        </Stack>

        <Group align='flex-end' justify='space-between' mt='xl'>
          {onSwitchToRegister &&
            (
              <Anchor
                component='button'
                type='button'
                c='dimmed'
                onClick={onSwitchToRegister}
                size='xs'
                underline='always'
              >
                Don't have an account? Register
              </Anchor>
            )}

          <Button type='submit' radius='xl'>
            Login
          </Button>
        </Group>
      </form>
    </Paper>
  );
}
