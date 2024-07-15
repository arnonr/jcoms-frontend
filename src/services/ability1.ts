import { createMongoAbility } from "@casl/ability";

export function defineAbilitiesFor(abilities: any) {
  const ability = createMongoAbility(abilities);
  return ability;
}
