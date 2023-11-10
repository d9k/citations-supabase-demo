import { useMemo } from 'react';
import { useToggle, upperFirst } from '@mantine/hooks';
import { useForm } from '@mantine/form';
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

export type LoginFormValues = {
  email: string;
  name: string;
  login: string;
  password: string;
  terms: boolean;
}

export type LoginFormProps = PaperProps & {
  demoField?: boolean;
  initialValues?: Partial<LoginFormValues>;
  projectName: string;
}

export const defaultLoginFormValues = (): Partial<LoginFormValues> => ({
  terms: true,
})

const fieldsValidateFuncrions = {
  email: (val?: string) => (/^\S+@\S+$/.test(val || '') ? null : 'Invalid email'),
  password: (val?: string) => ((val || '').length <= 6 ? 'Password should include at least 6 characters' : null),
}


/**
 * forked from
 * https://github.com/mantinedev/ui.mantine.dev/blob/6f9c568ee161ab3239b826af92dd48415e319cf8/lib/AuthenticationForm/AuthenticationForm.tsx
 */
export function LoginForm({projectName, initialValues = {}, ...props}: LoginFormProps) {
  const [type, toggle] = useToggle(['login', 'register']);

  const mergedInitialValues: Partial<LoginFormValues> = useMemo(() => (
    {...defaultLoginFormValues(), ...initialValues}
  ), [initialValues]);

  const form = useForm({
    initialValues: mergedInitialValues,
    validate: fieldsValidateFuncrions,
  });

  const isRegister = type === 'register';

  const inputSize = "lg";

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

      <form onSubmit={form.onSubmit(() => {})}>
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
            placeholder={isRegister ? "Email" : "Email of login"}
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

          {type === 'register' && (
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
            onClick={() => toggle()}
            size="xs"
            underline="always"
          >
            {type === 'register'
              ? 'Already have an account? Login'
              : "Don't have an account? Register"}
          </Anchor>

          <Button type="submit" radius="xl">
            {upperFirst(type)}
          </Button>
        </Group>
      </form>
    </Paper>
  );
}
