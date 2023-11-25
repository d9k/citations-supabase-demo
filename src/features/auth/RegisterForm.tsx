import { useCallback, useEffect, useMemo, useState } from 'react';
import { upperFirst, useToggle } from '@mantine/hooks';
import { useForm } from '@mantine/form';
// import { FormValidateInput } from '@mantine/form/types.d.ts';
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
import { EventInputChange } from '/~/shared/react/event-types.tsx';

export type RegisterFormValues = {
  email: string;
  name?: string;
  login: string;
  password: string;
  passwordRepeat: string;
  terms: boolean;
};

export type LoginFormProps = PaperProps & {
  demoField?: boolean;
  initialValues?: Partial<RegisterFormValues>;
  onSwitchToLogin?: () => void;
  onRegister?: (values: RegisterFormValues) => void;
  projectName: string;
  title?: string;
};

type UseFormParams = Parameters<typeof useForm<RegisterFormValues>>;

/** Error "A component is changing an uncontrolled input to be controlled" if skip any field default value */
export const defaultRegisterFormValues = (): RegisterFormValues => ({
  email: '',
  login: '',
  password: '',
  passwordRepeat: '',
  name: '',
  terms: true,
});

type UseFormParam1 = NonNullable<UseFormParams[0]>;
type UseFormParamValidate = NonNullable<UseFormParam1['validate']>;
type UseFormParamValidateObject = Exclude<UseFormParamValidate, Function>;
type UseFormParamValidateObjectRequired = Required<UseFormParamValidateObject>;

// const fieldsValidateFunctions: UseFormParamValidateObjectRequired = {
//   email: (
//     val?: string,
//   ) => (/^\S+@\S+$/.test(val || '') ? null : 'Invalid email'),
//   password: (
//     val?: string,
//   ) => ((val || '').length <= 6
//     ? 'Password should include at least 6 characters'
//     : null),
//   passwordRepeat: (
//     val?: string,
//     values?: RegisterFormValues,
//   ) => (val !== values?.password
//     ? 'Password repeart must match password'
//     : null),
//   name: (
//     val?: string,
//   ) => null,
//   login: (
//     val?: string,
//   ) => (/^[\w]{3,12}$/.test(val || '')
//     ? null
//     : 'Login must consist of 3-12 alphanumeric characters'),
//   // TODO
//   terms: (val?: boolean) => null,
// };

/**
 * forked from
 * https://github.com/mantinedev/ui.mantine.dev/blob/6f9c568ee161ab3239b826af92dd48415e319cf8/lib/AuthenticationForm/AuthenticationForm.tsx
 */
export function RegisterForm(
  {
    onRegister,
    onSwitchToLogin,
    projectName,
    title = 'Register',
    initialValues = {},
    ...props
  }: LoginFormProps,
) {
  const mergedInitialValues: RegisterFormValues = useMemo(() => (
    { ...defaultRegisterFormValues(), ...initialValues }
  ), [initialValues]);

  const form = useForm({
    initialValues: mergedInitialValues,
    validate: {
      email: (
        val?: string,
      ) => (/^\S+@\S+$/.test(val || '') ? null : 'Invalid email'),
      password: (
        val?: string,
      ) => (val && (val || '').length < 6
        ? 'Password should include at least 6 characters'
        : null),
      passwordRepeat: (
        val?: string,
        values?: RegisterFormValues,
      ) => (val !== values?.password
        ? 'Password repeart must match password'
        : null),
      name: (
        val?: string,
      ) => null,
      login: (
        val?: string,
      ) => (/^[\w]{3,12}$/.test(val || '') || !val
        ? null
        : 'Login must consist of 3-12 alphanumeric characters'),
      // TODO
      terms: (val?: boolean) => null,
    },
  });

  const inputSize = 'lg';

  // console.log('__TEST__: password props', form.getInputProps('password'));
  // console.log(
  //   '__TEST__: terms props',
  //   form.getInputProps('terms', { type: 'checkbox' }),
  // );

  return (
    <Paper radius='md' p='xl' withBorder {...props}>
      <Text size='lg' fw={500}>
        {`Register in ${projectName}`}
      </Text>

      {
        /* <Group grow mb="md" mt="md">
        <Button size="xs" radius="md" variant="default">Google</Button>
        <Button size="xs" radius="md" variant="default">Twitter</Button>
      </Group> */
      }

      <Space h='md' />

      {/* <Divider label="Or continue with email" labelPosition="center" my="lg" /> */}

      <form
        onSubmit={form.onSubmit((values) => {
          console.log(values);
          onRegister?.(values);
        })}
      >
        <Stack>
          <TextInput
            required
            size={inputSize}
            placeholder='Email'
            radius='md'
            {...form.getInputProps('email')}
          />

          <TextInput
            size={inputSize}
            placeholder='Your login'
            radius='md'
            {...form.getInputProps('login')}
          />

          <TextInput
            size={inputSize}
            placeholder='Your name'
            radius='md'
            {...form.getInputProps('name')}
          />

          {/* error={form.errors.password &&              'Password should include at least 6 characters'} */}

          <PasswordInput
            size={inputSize}
            placeholder='Your password'
            radius='md'
            {...form.getInputProps('password')}
          />

          <PasswordInput
            size={inputSize}
            placeholder='Repeat password'
            radius='md'
            {...form.getInputProps('passwordRepeat')}
          />

          <Space h='xs' />

          <Checkbox
            label='I accept terms and conditions'
            {...form.getInputProps('terms', { type: 'checkbox' })}
          />
        </Stack>

        <Group align='flex-end' justify='space-between' mt='xl'>
          {onSwitchToLogin &&
            (
              <Anchor
                component='button'
                type='button'
                c='dimmed'
                onClick={onSwitchToLogin}
                size='xs'
                underline='always'
              >
                Already have an account? Login
              </Anchor>
            )}

          <Button type='submit' radius='xl'>
            Register
          </Button>
        </Group>
      </form>
    </Paper>
  );
}
