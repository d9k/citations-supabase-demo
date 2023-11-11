import { useCallback, useEffect, useMemo, useState } from 'react';
import { useToggle, upperFirst } from '@mantine/hooks';
import { useForm } from '@mantine/form';
import { FormValidateInput } from '@mantine/form/types.d.ts';
import {
  TextInput,
  PasswordInput,
  Text,
  Paper,
  Group,
  PaperProps,
  Button,
  Divider,
  Checkbox,
  Anchor,
  Stack,
  Space,
} from '@mantine/core';


export enum LoginFormType {
  login = 'login',
  register = 'register',
}

export type LoginValues = {
  loginOrEmail: string;
  password: string;
}

export type RegisterValues = {
  email: string;
  name: string;
  login: string;
  password: string;
  terms: boolean;
}

export type LoginFormValues  = RegisterValues & {};

export type LoginFormProps = PaperProps & {
  demoField?: boolean;
  initialValues?: Partial<LoginFormValues>;
  isRegisterForm?: boolean;
  onChangeRegisterForm? : (newRegisterForm: boolean) => void;
  onLogin: (values: LoginValues) => void;
  onRegister?: (values: RegisterValues) => void;
  projectName: string;
}

export type UseFormParams = Parameters<typeof useForm<LoginFormValues>>;

/** Error "A component is changing an uncontrolled input to be controlled" if skip any field default value */
export const defaultLoginFormValues = (): LoginFormValues => ({
  email: '',
  login: '',
  password: '',
  name: '',
  terms: true,
})

type UseFormParam1 = NonNullable<UseFormParams[0]>;
type UseFormParamValidate = NonNullable<UseFormParam1['validate']>;
type UseFormParamValidateObject = Exclude<UseFormParamValidate, Function>;
type UseFormParamValidateObjectRequired = Required<UseFormParamValidateObject>;

const fieldsValidateFunctions: UseFormParamValidateObjectRequired = {
  email: (val?: string) => (/^\S+@\S+$/.test(val || '') ? null : 'Invalid email'),
  password: (val?: string) => ((val || '').length <= 6 ? 'Password should include at least 6 characters' : null),
  name: (val?: string) => ((val || '').length <= 6 ? 'Password should include at least 6 characters' : null),
  login: (val?: string) => (/^[\w]{3,12}$/.test(val || '') ? null : 'Login must consist of 3-12 alphanumeric characters'),

  // TODO
  terms: (val?: boolean) => null,
}

type GetValuesType =
  ((values: LoginFormValues, isRegister: true) => RegisterValues)
  | ((values: LoginFormValues, isRegister: false) => LoginValues);


/**
 * forked from
 * https://github.com/mantinedev/ui.mantine.dev/blob/6f9c568ee161ab3239b826af92dd48415e319cf8/lib/AuthenticationForm/AuthenticationForm.tsx
 */
export function LoginForm(
  {
    isRegisterForm = false,
    onChangeRegisterForm,
    projectName,
    initialValues = {},
    ...props
  }: LoginFormProps
) {
  const mergedInitialValues: LoginFormValues = useMemo(() => (
    {...defaultLoginFormValues(), ...initialValues}
  ), [initialValues]);

  const [isRegister, setIsRegister] = useState(isRegisterForm);

  // TODO hook to merge prop and inner current value and provide onUpdate callback
  useEffect(() => {
    setIsRegister(isRegisterForm);
  }, [isRegisterForm]);

  const handleToggleRegister = useCallback(() => {
    let newValue = false;

    setIsRegister(
      (v) => {
        newValue = !v;
        return newValue;
      }
    );

    onChangeRegisterForm?.(newValue);
  }, [])

  const form = useForm({
    initialValues: mergedInitialValues,
    validate: fieldsValidateFunctions,
  });

  const inputSize = "lg";

  const handleSubmit = useCallback(form.onSubmit(
    (values) => {

    }
  ), [])

  return (
    <Paper radius="md" p="xl" withBorder {...props}>
      <Text size="lg" fw={500}>
        { isRegister ? `Register in ${projectName}` : `Login to ${projectName}` }
      </Text>

      {/* <Group grow mb="md" mt="md">
        <Button size="xs" radius="md" variant="default">Google</Button>
        <Button size="xs" radius="md" variant="default">Twitter</Button>
      </Group> */}

      <Space h="md" />

      {/* <Divider label="Or continue with email" labelPosition="center" my="lg" /> */}

      <form onSubmit={handleSubmit}>
        <Stack>
          {isRegister && (
            <TextInput
              required
              size={inputSize}
              placeholder="Your name"
              value={form.values.name}
              onChange={(event) => form.setFieldValue('name', event.currentTarget.value)}
              radius="md"
            />
          )}

          {isRegister && (
            <TextInput
              required
              size={inputSize}
              placeholder="Your login"
              value={form.values.login}
              onChange={(event) => form.setFieldValue('login', event.currentTarget.value)}
              radius="md"
            />
          )}

          <TextInput
            required
            size={inputSize}
            placeholder={isRegister ? "Email" : "Email or login"}
            value={form.values.email}
            onChange={(event) => form.setFieldValue('email', event.currentTarget.value)}
            error={form.errors.email && 'Invalid email'}
            radius="md"
          />

          <PasswordInput
            required
            size={inputSize}
            placeholder="Your password"
            value={form.values.password}
            onChange={(event) => form.setFieldValue('password', event.currentTarget.value)}
            error={form.errors.password && 'Password should include at least 6 characters'}
            radius="md"
          />

          <Space h="xs" />

          {isRegister && (
            <Checkbox
              label="I accept terms and conditions"
              checked={form.values.terms}
              onChange={(event) => form.setFieldValue('terms', event.currentTarget.checked)}
            />
          )}
        </Stack>


        <Group align="flex-end" justify="space-between" mt="xl">
          <Anchor
            component="button"
            type="button"
            c="dimmed"
            onClick={() => handleToggleRegister()}
            size="xs"
            underline="always"
          >
            {isRegister
              ? 'Already have an account? Login'
              : "Don't have an account? Register"}
          </Anchor>

          <Button type="submit" radius="xl">
            {isRegister ? 'Register' : 'Login'}
          </Button>
        </Group>
      </form>
    </Paper>
  );
}
