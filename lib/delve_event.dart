import "dart:developer";

import "character.dart";

 class ComEvent {
  int rounds = 0;

  MonsterCharacter monster = MonsterCharacter("", 1, 1);
  
  ComEvent(MonsterCharacter mon) {
    monster = mon;
  }

  String fight(PlayerCharacter pc){
    while ((pc.currentHP > 0) && (monster.currentHP > 0)) {
      if (pc.hitsAttack(monster.stats[2])) {
        monster.takeDamage(pc.weaponDamage());
      }
      if (monster.currentHP > 0) {
        pc.attacked(monster.monsterAttack(), monster.monsterDamage());
      }
      log("Player: ${pc.currentHP} Monster ${monster.currentHP}");
    }
    monster.fillHP();
    if (pc.currentHP <= 0) {
      return "${pc.name} loses a fight against a ${monster.name} and is forced to crawl back!";
    } else {
      pc.gold += monster.goldGain; pc.xp += monster.xpGain;
      return "${pc.name} wins a fight against a ${monster.name} and reaps the rewards!";
    }
  }
}