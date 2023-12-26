import { Button, Modal, ModalProps } from '@mantine/core';
import { RecordAny } from '/~/shared/lib/ts/record-any.ts';
import { FnKeyGetter } from '/~/shared/api/supabase/types/keys.types.ts';
import { JsonView } from '/~/shared/ui/json-view.tsx';
import { useState } from 'react';

export type ModalDeleteRowProps = Pick<ModalProps, 'opened' | 'onClose'> & {
  rowToDelete?: RecordAny | null;
  rowKeyGetter: FnKeyGetter;
  onRowDelete: (row: RecordAny) => Promise<boolean>;
};

export const ELEMENT_NAME = 'ModalDeleteRow';

export const ModalDeleteRow = (
  { opened, onClose, onRowDelete, rowToDelete = null, rowKeyGetter }:
    ModalDeleteRowProps,
) => {
  const key = rowKeyGetter(rowToDelete);
  const [deleting, setDeleting] = useState(false);

  const handleDelete = async () => {
    setDeleting(true);

    if (!rowToDelete) {
      throw Error(`${ELEMENT_NAME}: no row to delete`);
    }

    const result = await onRowDelete?.(rowToDelete);
    setDeleting(false);

    if (result) {
      onClose();
    }
  };

  return (
    <Modal
      opened={opened}
      onClose={onClose}
      title={`Delete item #${key} confirmation`}
    >
      <div>Are you sure you want to delete item #{key}?</div>
      <JsonView data={rowToDelete} />
      <Button
        loading={deleting}
        onClick={handleDelete}
        color='red'
        mt='md'
      >
        Delete
      </Button>
    </Modal>
  );
};
