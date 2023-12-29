import { envGetNonRequired } from '/~/shared/lib/deno/env.ts';
import * as path from 'std/path';

export async function runCommandWithPipedOutput(
  command: string | URL,
  args: string[] = [],
  options: Deno.CommandOptions = {},
) {
  const newProcessEnv: Record<string, string> = {};

  const PATH = envGetNonRequired('PATH');

  if (PATH) {
    // console.debug('Setting PATH to', PATH);
    newProcessEnv['PATH'] = PATH;
  }

  const commandObj = new Deno.Command(command, {
    args,
    env: { ...newProcessEnv, ...(options.env || {}) },
    stdout: 'piped',
    stderr: 'piped',
    ...options,
  });

  console.debug('Running command with piped output', command, args);

  const process = commandObj.spawn();

  const pipeToOptions: StreamPipeOptions = {
    preventClose: true,
    preventCancel: true,
    preventAbort: true,
  };

  process.stdout.pipeTo(Deno.stdout.writable, pipeToOptions);
  process.stderr.pipeTo(Deno.stderr.writable, pipeToOptions);

  const { success, code, signal } = await process.status;

  // const { code, stdout, stderr } = await command.output();
  // console.log('code:', command);
  // console.log('stdout:', new TextDecoder().decode(stdout));
  // console.log('stderr', new TextDecoder().decode(stderr));

  // streams.copy(stdout, Deno.stdout);
  // streams.copy(stderr, Deno.stderr);

  // Deno.close(process.pid)

  // try {
  //   process.kill();
  // } catch (e) {
  //   console.error(e);
  // }

  console.log(`Done! success: ${success}, code: ${code}, signal: ${signal}`);

  return {
    command,
    process,
    success,
    code,
    signal,
  };
}
