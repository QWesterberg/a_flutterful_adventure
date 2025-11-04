import "dart:math";


abstract class BaseCharacter<T extends Object> {

  String name = "", job = "", species = "", portraitID = "";   
  
  int gold = 0, level = 1, hpMod = 10, mpMod = 10, armorLevel = 1, weaponLevel = 1, baseWeaponDie = 6;

  /*Stats by index:
  0 - Hit Points: How much damage you can take.
  1 - Magic Points: How much you can cast spells.
  2 - Attack: Increases the accuracy of your attacks.
  3 - Defense: Decrease chance you will be hit.
  4 - Melee Damage Bonus: Bonus to damage with Melee attacks.
  5 - Casting Bonus: Bonus to casting with Magic.
  6 - Fort: Saving Throw based on physical resistance.
  7 - Reflex: Saving Throw based on reflexes and agility.
  8 - Will: Saving Throw based on mental resilience and willpower.
  9 - Crit Chance: Chance you will get a critical hit. 
  10 - Discount: Amount purchases are decreased by.
  */
  List stats = <int> [/*Max HP*/ 10, /*Max MP*/10, /*ATK*/ 0, /*DEF*/ 10, /*DMG+*/ 0, /*Cast+*/0, /*ST*/0, 0, 0, /*Crit%*/5, /*Discount */ 0];
  List attributes = <Attribute> [
    Attribute("Strength", "Sheer physical power-boosts Hit Points and Melee Damage Bonus."),
    Attribute("Agility", "Reflexes and quick movement - boosts Reflex and Defense."),
    Attribute("Dexterity", "Finesse and skill with hands - boosts Attack."),
    Attribute("Endurance", "Stamina and resilience-boosts Hit Points and Fort."),
    Attribute("Intelligence", "Knowledge and memory - boosts Magic Points and Casting Bonus."),
    Attribute("Spirit", "Force of will and connection to the spiritual realm - boosts Magic Points and Will."),
    Attribute("Charisma", "Good looks and personality - boosts Defense and Discount."),
    Attribute("Luck", "Sheer blind luck - boosts Crit Chance and Saving Throws.")
  ];

  double currentHP = 10, currentMP = 10;

  void setName(String string) { name = string; }

  void setJob(String string) {  job = string; }


  void setSpecies(String string) {  species = string;  }

  void setPortrait(String string) {  portraitID = string;}

  void setAttributes(List<int> nums) { 
    for (int i = 0; i<8; i++) {
      attributes[i].setVal(nums[i]);
    }
  }

  void setRandAttributes(int r, int b) {
    for (int i = 0; i<8; i++) {
      attributes[i].setRandVal(r, b);
    }
  }

  void modHP(double a) { currentHP += a;
    if (currentHP > stats[0]) {
      currentHP = (stats[0])/2 * 2;
    }
  }

  void fillHP() { currentHP = (stats[0])/2 * 2;}

  void modMP(double a) { currentMP += a;
    if (currentMP > stats[1]) {
      currentMP =(stats[1])/2 * 2;
    }
  }

  void fillMP() { currentMP = (stats[1])/2 * 2;}
  
  void setBaseStats () {
    for (int i = 0; i<8; i++) {
      attributes[i].updateMod();
    }
    stats[0] = attributes[0].mod*5 + attributes[3].mod*10 + hpMod;
    stats[1] = attributes[4].mod*5 + attributes[5].mod*10 + mpMod;
    stats[2] = attributes[2].mod;
    stats[3] = 10 + attributes[1].mod + attributes[6].mod;
    stats[4] = attributes[0].mod;
    stats[5] = attributes[4].mod;
    stats[6] = attributes[3].mod + attributes[7].mod;
    stats[7] = attributes[1].mod + attributes[7].mod;
    stats[8] = attributes[5].mod + attributes[7].mod;
    stats[9] = attributes[7].mod + 5;
    stats[10] = attributes[6].mod;
  }
}


class Attribute {
  String name = "", description;
  int val = 5, mod = 0;

  Attribute(this.name, this.description);

  void setRandVal (int r, int b) {
    val = b + Random().nextInt(r);
    mod = val - 5;
  }

  void setVal (int a) {
    val = a;
    updateMod();
  } 

  void updateMod () {
    mod = val - 5;
  }

  void upVal (int a) {
    val++;
    updateMod();
  }
}

class PlayerCharacter extends BaseCharacter{
  int xp = 0, xpNeeded = 10;
  List traits = <Trait>[], spells = <Spell>[];

  PlayerCharacter(String nam, String jo, String spe, String por) {
   super.name = nam;
   super.job = jo;
   super.species = spe;
   super.portraitID = por;
  }
  
  void levelUp() {
    if (xp >= xpNeeded) {
      xp -= xpNeeded;
      level++;
      xpNeeded *= super.level + 2;
      super.hpMod += 5;
      super.mpMod += 5;
      super.attributes[Random().nextInt(8)].upVal(1);
      super.setBaseStats();
      super.fillHP();
      super.fillMP();
    }
  }

  bool hitsAttack (num target) {
    num attackRoll = Random().nextInt(20) + stats[2];
    if (attackRoll >= target) {
      return true;
    } else {
      return false;
    }
  }

  num weaponDamage() {
    return Random().nextInt(super.baseWeaponDie) + stats[4];
  }

  num spellDamage(int spellDamageDie) {
    return Random().nextInt(spellDamageDie) + stats[5];
  }

  void attacked (num attack, num damage) {
    if (attack > stats[3]){
      super.modHP(-damage/(super.armorLevel));
    }
  }

  void castSpell(){}

/*
TypeNum effects:
-0: Applies modifier to an attribute (0-7 on the array)
-1: Boosts a stat directly (hit points, magic points, Attack, Defense, critChance)
-2: Causes regen effect at percentile (0 for HP, 1 for MP)
-3: Percentile increase to stat (same as 1)
(Feel free to come up with more!)
*/
  void applyTrait(Trait trait) {
    if (trait.typeNum == 0) {
      super.attributes[trait.typeNum2] = attributes[trait.typeNum2] + trait.mod;
    }
    else if (trait.typeNum == 1) {
      super.stats[trait.typeNum2] = stats[trait.typeNum2] + trait.mod;
    }
    else if (trait.typeNum == 2) {
      if (trait.typeNum2 == 0) {
        if (super.currentHP < super.stats[0]) {          super.currentHP += trait.mod/100;        }
        else {          super.currentHP = super.stats[0];        }
      }
      if (trait.typeNum2 == 0) {
        if (super.currentMP < super.stats[1]) {          super.currentMP += trait.mod/100;        }
        else {          super.currentMP = super.stats[1];        }
      }
      
    }
    else if (trait.typeNum == 3) {
      super.stats[trait.typeNum2] = stats[trait.typeNum2] + (stats[trait.typeNum2]*trait.mod)/100;
    }
  }

  

}

class Trait {
  String name = "", description;
  int mod = 0, typeNum = 0, typeNum2 = 0;
  
  Trait(this.name, this.description, this.mod, this.typeNum, this.typeNum2);
}

class MonsterCharacter extends BaseCharacter {
  int xpGain = 0, goldGain = 0;

  bool isDead = false;

  MonsterCharacter(String nam, int xp, int gol) {
    super.name = nam;
    xpGain = xp;
    goldGain = gol;
  }

  num monsterAttack () {
    return Random().nextInt(20) + super.stats[2];
  }

  num monsterDamage() {
    return Random().nextInt(super.baseWeaponDie) + stats[4];
  }

  void takeDamage (num damage) {
      super.modHP(-damage/(super.armorLevel));
  }

}

class Spell {
  
  String spellName = "", spellDescription = "";

  num spellCost = 0, spellPower = 0;

  String effect = "";

  Spell (String nam, String desc, num cost, num power, String eff) {
    spellName = nam;
    spellDescription = desc;
    spellCost = cost;
    spellPower = power;
    effect = eff;
  }

}