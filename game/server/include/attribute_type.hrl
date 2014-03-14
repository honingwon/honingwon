%%%%%%%%%%%%%%%%%装备自由固定隐藏属性%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-define(ATTR_ATTACK,  1).                           %%攻击力
-define(ATTR_DEFENSE,  2).					        %%防御

-define(ATTR_DAMAGE, 3).                            %%普通伤害

-define(ATTR_MUMPHURTATT, 4).					    %%外功攻击力
-define(ATTR_MAGICHURTATT, 5).                      %%内力攻击力
-define(ATTR_FARHURTATT, 6).                        %%远程攻击力
-define(ATTR_MUMPDEFENSE, 7).                       %%外功防御
-define(ATTR_MAGICDEFENCE, 8).                      %%内力防御
-define(ATTR_FARDEFENSE, 9).                        %%远程防御
-define(ATTR_MUMPHURT, 10).                         %%外功伤害
-define(ATTR_MAGICHURT, 11).                        %%内力伤害
-define(ATTR_FARHURT, 12).                          %%远程伤害
-define(ATTR_HP, 13).                               %%生命
-define(ATTR_MP, 14).                               %%法力
-define(ATTR_POWERHIT, 15).                         %%致命一击
-define(ATTR_DELIGENCY, 16).                        %%坚韧
-define(ATTR_HITTARGET, 17).                        %%命中率	
-define(ATTR_DUCK, 18).                             %%回避率	
-define(ATTR_MUMPAVOIDINHURT, 19).                  %%斗气免伤
-define(ATTR_FARAVOIDINHURT, 20).                   %%远程免伤
-define(ATTR_MAGICAVOIDINHURT, 21).                 %%魔法免伤	

-define(ATTR_SUPPRESSIVE_ATT, 22).                  %%攻击压制
-define(ATTR_SUPPRESSIVE_DEFEN,  23).               %%防御压制
-define(ATTR_RESUME_HP_SPEED, 24).                  %%生命回复速度
-define(ATTR_RESUME_MP_SPEED, 25).                  %%法力回复速度

-define(ATTR_ATT_ATTACK, 26).                  		%%宠物属攻

%% -define(ATTR_HUMAN_ATTACK, 26).                     %%对人种族怪物攻击力
%% -define(ATTR_ORC_ATTACK, 27).                       %%对魔种族怪物攻击力
%% -define(ATTR_NIGHTMARE_ATTACK, 28).                 %%对魔种族怪物攻击力
%% -define(ATTR_EVILKIND_ATTACK, 29).                  %%对妖种族怪物攻击力
%% 
%% -define(ATTR_HUMAN_DEFENSE, 30).                    %%对人种族怪物防御力
%% -define(ATTR_ORC_DEFENSE, 31).                      %%对兽种族怪物防御力
%% -define(ATTR_NIGHTMARE_DEFENSE, 32).                %%对魔种族怪物防御力
%% -define(ATTR_EVILKIND_DEFENSE, 33).                 %%对妖种族怪物防御力
%% 
%% -define(ATTR_HUMAN_DEMAGE, 34).                    %%对人种族怪物伤害
%% -define(ATTR_ORC_DEMAGE, 35).                      %%对兽种族怪物伤害
%% -define(ATTR_NIGHTMARE_DEMAGE, 36).                %%对魔种族怪物伤害
%% -define(ATTR_EVILKIND_DEMAGE, 37).                 %%对妖种族怪物伤害

%% -define(ATTR_DEMAGE_TO_SHANGWU, 38).              %%针对尚武伤害
%% -define(ATTR_DEMAGE_TO_XIAOYAO, 39).              %%针对逍遥伤害
%% -define(ATTR_DEMAGE_TO_LIUXING, 40).              %%针对流星伤害
%% 
%% -define(ATTR_DEMAGE_FROM_SHANGWU, 41).            %%受到尚武伤害
%% -define(ATTR_DEMAGE_FROM_XIAOYAO, 42).            %%受到逍遥伤害
%% -define(ATTR_DEMAGE_FROM_LIUXING, 43).            %%受到流星伤害

-define(ATTR_KEEPOFF, 44).                        %%格挡
-define(ATTR_MOVE_SPEED,  45).                    %%移动速度
-define(ATTR_ATTACK_SPEED,  46).                  %%攻击速度

-define(ATTR_PARALYZE_STATE, 47).                 %%附带麻痹状态
-define(ATTR_FAINT_STATE, 48).                    %%附带昏迷状态
-define(ATTR_CURSE_STATE, 49).                    %%附带诅咒状态
-define(ATTR_CLOSE_MOVE_STATE, 50).               %%附带封脚状态
-define(ATTR_CLOSE_SKILL_STATE, 51).              %%附带封招状态

-define(ATTR_RESISTANCE_PARALYZE_STATE, 52).      %%附带麻痹状态抗性
-define(ATTR_RESISTANCE_FAINT_STATE, 53).         %%附带昏迷状态抗性
-define(ATTR_RESISTANCE_CURSE_STATE, 54).         %%附带诅咒状态抗性
-define(ATTR_RESISTANCE_CLOSE_MOVE_STATE, 55).    %%附带封脚状态抗性
-define(ATTR_RESISTANCE_CLOSE_SKILL_STATE, 56).   %%附带封招状态抗性

-define(ATTR_EXTENT_TOTAL_HP,	82).			  %%增加生命上限
-define(ATTR_EXTENT_HP,	83).			  			%%恢复生命

-define(Attr_TARGET_Attack, 201).                 %%目标的攻击
-define(Attr_TARGET_DEFENSE, 202).                %%目标的防御
-define(Attr_TARGET_HITTARGET, 203).              %%目标的命中
-define(ATTR_TARGET_DUCK, 204).                   %%目标的闪避
-define(ATTR_TARGET_DELIGENCY, 205).              %%目标的坚韧
-define(ATTR_TARGET_POWERHIT, 206).               %%目标的暴击（致命一击）
-define(ATTR_TARGET_KEEPOFF, 207).                %%目标的格挡

-define(Attr_TARGET_MumphurtAtt, 208).			  %%目标的斗气攻击力
-define(Attr_TARGET_MagichurtAtt, 209).           %%目标的魔法攻击力
-define(Attr_TARGET_FarhurtAtt, 210).             %%目标的远程攻击力
-define(Attr_TARGET_Mumpdefense, 211).            %%目标的斗气防御
-define(Attr_TARGET_Magicdefence, 212).           %%目标的魔法防御
-define(Attr_TARGET_Fardefense, 213).             %%目标的远程防御
-define(Attr_TARGET_Mumpavoidinhurt, 214).        %%目标的斗气免伤
-define(Attr_TARGET_Faravoidinhurt, 215).         %%目标的远程免伤
-define(Attr_TARGET_Magicavoidinhurt, 216).       %%目标的魔法免伤	

-define(Attr_TARGET_HP, 217).                     %%目标的生命
-define(Attr_TARGET_MP, 218).                     %%目标的法力
-define(Attr_TARGET_MOVE_SPEED, 219).             %%目标的移动速度
-define(Attr_TARGET_ATTACK_SPEED, 220).           %%目标的攻击速度

-define(ATTR_PHYSICS_HURT_ADD,230).				  %%物理攻击加成
-define(ATTR_RANGE_HURT_ADD,231).         	      %%远程攻击加成
-define(ATTR_MAGIC_HURT_ADD,232).         	      %%内力攻击加成
-define(ATTR_VINDICTIVE_HURT_ADD,233).         	  %%外功攻击加成



-define(ATTR_TARGET_RELIVE,250).				  %%目标复活

-define(Attr_TARGET_BREAK_SKILL, 501).            %%打断技能
-define(Attr_TARGET_HITDOWN, 502).				  %%击晕对象




