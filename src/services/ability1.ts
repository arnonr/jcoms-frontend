import { defineAbility } from '@casl/ability';

export const defineAbilitiesFor = (user: any) => {
  return defineAbility((can, cannot) => {
    if (user.role === 'admin') {
      can('manage', 'all');
    } else if (user.role === 'editor') {
      can('read', 'all');
      can('create', 'Article');
      can('update', 'Article');
    } else {
      can('read', 'Article');
    }
  });
};

export const ability = defineAbilitiesFor({ role: 'guest' });