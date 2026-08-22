-- 基于孤独之星俱乐部/流泪猫猫头重置的检查文本
-- 用于《明日方舟》角色《令》的检查文案
-- 几乎完全重置了所有检查文案
-- 基于自己的理解增加大量诗句、以类似令的口吻对《饥荒》中各种事件、物品进行描述
-- 水平不算很高，总会有部分文案吃书，敬请谅解
-- 
-- 
-- by 流光落语	




return
{
--  尝试进行动作失败
	ACTIONFAIL =
	{
		--  通用
		GENERIC =
		{
			ITEMMIMIC = "终是徒有虚形。",	--使用拟态蠕虫模仿的物品时显形脱手
		},
		-- 刮毛
		SHAVE =
		{
			AWAKEBEEFALO = "或许我该带它去我的梦里，不然直接给它剃毛它肯定会发狂。",		--给醒着的牛刮毛
			GENERIC = "无可剃兮，何以强为。",		--刮牛毛失败
			NOBITS = "莫贪得无厌。",		--不能给没毛的牛刮毛
			REFUSE = "only_used_by_woodie",		--拒绝刮胡子（伍迪专用）
			SOMEONEELSESBEEFALO = "有主之灵，毋动。",		--不能刮队友牛的毛
		},
		-- (向容器内)存放物品
		STORE =
		{
			GENERIC = "盈矣，盈矣。",		--存放东西失败
			NOTALLOWED = "它自去处，强求不得。",		--存放东西不被允许
			INUSE = "先来后到。",		--别人正在用箱子
			NOTMASTERCHEF = "还是让幺弟来吧。",		--使用大厨厨具
		},
		-- 翻找(打开容器)
		RUMMAGE =
		{
			GENERIC = "打不开。",		--打开箱子失败
			INUSE = "先来后到。",		--不能打开箱子，别人正在使用
			NOTMASTERCHEF = "试试幺弟给我教的手艺。",		--使用大厨厨具
			NOTAMERM = "交由他们来做，我们还有场千秋大梦。",	--非鱼人不能打开鱼人工具棚和军械库
		},
		-- 烹饪
		COOK =
		{
			GENERIC = "当年在玉门，将士们也曾烹石壮饥。",		--做饭失败
			INUSE = "看来他不需要帮厨。",		--做饭失败，别人在用锅
			TOOFAR = "就算是幺弟也不能在离锅这么远的地方做饭。",		--做饭失败，距离太远
		},
		-- 递物品
		GIVE =
		{
			-- 向生物给予失败
			DEAD = "生死两茫。",		--给予失败，目标死亡
			SLEEPING = "梦里不知身是客，一晌贪欢。",		--给予失败，目标睡觉
			BUSY = "忙日苦多。",		--给予失败，目标正忙
			NOMOON = "昏暗无日，月华无光。得在地面上才行。",		--洞穴里无法使用天体传送门换人
			NOTATRIUMKEY = "凿枘不和。",		--远古大门钥匙不对
			NOTSTAFF = "它只能接引法杖。",		--给月石祭坛的物品不是法杖
			-- 灵魂与告密的心
			ABIGAILHEART = "天涯一隔，两端多远，不敌阴阳两相望。",		--给阿比盖尔告密的心，无效
			GHOSTHEART = "亡者不可生，来者犹可救。",		--给鬼魂告密的心，无效
			-- 织影者复活相关
			CANTSHADOWREVIVE = "或许我该大梦一场再来。",		--远古大门冷却中
			WRONGSHADOWFORM = "奇怪的骨骼摆放方式，方看了估计会打人。",		--化石骨架形态错误，无法用心脏复活
			-- 蘑菇农场相关
			MUSHROOMFARM_NEEDSSHROOM = "无以种蕈，何以采蕈。",		--蘑菇农场需要先种蘑菇
			MUSHROOMFARM_NEEDSLOG = "这块农场失去了“生机”，需要补充。",		--蘑菇农场需要活木
			MUSHROOMFARM_NOMOONALLOWED = "许有夕娥，采种月蕈。",	--不是点了技能的植物人试图在蘑菇农场种月蘑菇
			-- 陶轮相关
			DUPLICATE = "满腹经纶，已有成竹。",		--给雕像桌子已经学习过的图纸
			NOTSCULPTABLE = "刻石无刀，焉用指摧？",		--给陶艺圆盘的东西不对
			SLOTFULL = "慢工当出细活。",		--已经放了材料后，再给雕像桌子再给一个材料
			-- 猪王年活动-抢元宝游戏
			PIGKINGGAME_MESSY = "方寸之距，何以尽兴！",		--猪王旁边有建筑，不能开始抢元宝
			PIGKINGGAME_DANGER = "征蓬未定，甲胄在身。",		--危险，不能开始抢元宝
			PIGKINGGAME_TOOLATE = "夜深人定，毋再嬉闹。",		--不是白天，不能开始抢元宝
			-- 鸦年华活动-各项游戏
			CARNIVALGAME_INVALID_ITEM = "需要去买些代币才行。",		--非代币无法开启鸦年华游戏
			CARNIVALGAME_ALREADY_PLAYING = "已然在局中。",		--鸦年华游戏正在进行中
			-- 暴食活动-向暴食祭祀
			FOODFULL = "祭品毋多。",		--祭坛上已经有菜肴了（暴食）
			NOTDISH = "就算是我也不会喜欢吃这个。",		--祭坛上不能摆非料理（暴食）
			-- 盒中泰拉
			TERRARIUM_REFUSE = "这种燃料不行，它需要椅子特殊的燃料。",		--给泰拉瑞亚非噩梦燃料
			TERRARIUM_COOLDOWN = "等这方天地再孕育一番吧。",	-- 泰拉瑞亚冷却中
			-- 月亮码头女王/猴子女王交易
			NOTAMONKEY = "这门外语还是以后再学吧。",	--非芜猴玩家不能给予月亮码头女王物品
			QUEENBUSY = "等她闲下来吧，猴急不得。",	--月亮码头女王忙碌中无法接受物品
			-- 向远古档案馆塞宝石
			NOTGEM = "世间一艺尚如此，何况学业非专攻。",		--给的不是宝石
			WRONGGEM = "这块宝石应当另有用途。",		--给错了宝石
			--未学习天赋，无法给宝石发电机安装纯粹辉煌和启迪碎片
			NOGENERATORSKILL = "世间一艺尚如此，何况学业非专攻。",	
			-- 韦伯(蜘蛛人)试图给物品栏中的蜘蛛戴帽子
			SPIDERNOHAT = "或许得放下来才行。",		--物品栏里的蜘蛛不能戴帽子
			
			GENERIC = "或许我应该再试试？",		--给予失败
		},
		-- 给予玩家单件物品
		GIVETOPLAYER =
		{
			FULL = "随身带这么多东西？倒是让我想起了一个弟弟。",		--给玩家一个东西，但是背包满了
			DEAD = "生死两茫。",		--给死亡的玩家一个东西
			SLEEPING = "梦里不知身是客，一晌贪欢。",		--给睡觉的玩家一个东西
			BUSY = "忙日苦多。",		--给忙碌的玩家一个东西
		},
		-- 给予玩家整组物品
		GIVEALLTOPLAYER =
		{
			FULL = "随身带这么多东西？倒是让我想起了一个弟弟。",		--给人一组东西，但是背包满了
			DEAD = "生死两茫。",		--给于死去的玩家一组物品
			SLEEPING = "梦里不知身是客，一晌贪欢。",		--给于正在睡觉的玩家一组物品
			BUSY = "忙日苦多。",		--给于正在忙碌的玩家一组物品
		},
		-- 给小木牌绘画
		WRITE =
		{
			GENERIC = "笔法乱了，重写吧。",		--写字失败
			INUSE = "观摩观摩。",		--别人正在写字
		},
		DRAW =
		{
			NOIMAGE = "摹绘需观形，没有参照，就连形似都做不到。",		--画图缺乏参照物
		},
		-- 换装
		CHANGEIN =
		{
			GENERIC = "也罢，再去巡视一圈。",		--换装失败 
			BURNING = "绫罗绸缎，一息烬尽。先救火吧。",		--换装失败，衣柜着火了
			INUSE = "待他打扮一番吧。",		--衣橱有人占用
			-- 皮弗娄牛美妆台
			NOTENOUGHHAIR = "看来它需要等毛发长出来才能接受打扮了。",		--皮弗娄牛美妆台上的牛被剃毛了
			NOOCCUPANT = "我们的主角还未登台。",		--皮弗娄牛美妆台上没有牛
		},
		-- 制造肉雕像血量不足
		ATTUNE =
		{
			NOHEALTH = "壮士断腕，但现在应量力而行。",		--制造肉雕像血量不足
		},
		-- 骑牛
		MOUNT =
		{
			TARGETINCOMBAT = "其角似刀，其目若炬，可不要被误伤了。",		--骑乘失败，牛正在战斗
			INUSE = "它应该载不动两个人。",		--骑乘失败，牛被占据
			SLEEPING = "在梦里它会变成蝴蝶吗？或许吧。",	--牛在睡觉
		},
		-- 栓牛
		HITCHUP =	--把牛栓到美妆台或展示台上
		{
			NEEDBEEF = "铃铛似乎能和那些丰蹄交朋友。",		--没有牛
			NEEDBEEF_CLOSER = "或许我该离得近些？",		--牛离得太远
			BEEF_HITCHED = "它在那里了。",		--已经拴上牛了
			INMOOD = "等它败败火再试试。",		--不能栓发情的牛
		},
		-- 上鞍
		SADDLE =
		{
			TARGETINCOMBAT = "发狂的丰蹄，先等它冷静下来吧。",		--无法给战斗状态的牛上鞍
		},
		-- 学习/使用蓝图类道具
		TEACH =
		{			
			KNOWN = "学海无涯，技艺有穷。",		--学习已经知道的蓝图
			CANTLEARN = "能力不足？就当这场梦中的些许遗憾吧。",		--学习无法学习的蓝图
			WRONGWORLD = "来自其他世界的山川，眼下只是无用之卷。",		--学习另外一个世界的地图
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "我应该去海边来比对这份地图的位置。",		--当前世界无法解析瓶中信的地图标记，比如洞穴
			STASH_MAP_NOT_FOUND = "没有找到这张地图上的标识物，或许它在一个深远的海洋中。",	--当前世界无法从海岛地图中读取到藏物处
		},
		-- 打包纸
		WRAPBUNDLE =
		{
			EMPTY = "空空如也，总得放点什么吧。",		--打包失败，打包纸里没有东西
		},
		-- 拿起错误的物品
		PICKUP =
		{
			RESTRICTION = "回去再练练吧。",		--捡起错误的武器（熔炉）
			INUSE = "先来后到。",		--捡起对象的容器正在被别人打开
			NOTMINE_SPIDER = "only_used_by_webber",		--无法捡别人的蜘蛛（韦伯专用）
			NOTMINE_YOTC =
			{
				"不告而取喂之窃。",		--不能捡别人的胡萝卜鼠
				"用人物，需明求。",		--不能捡别人的胡萝卜鼠
			},
			FULL_OF_CURSES = "某种诅咒？让它离远些吧。",	--物品栏已满，装不下诅咒饰品
		},
		-- 暴食相关
		--换盘子（暴食）
		REPLATE =
		{
			MISMATCH = "需要另一种餐具。",		--换盘子换错了，比如用碗换碟子
			SAMEDISH = "正好。",		--已经换了盘子，不需要再换了
		},
		--谨慎的屠杀（暴食）
		SLAUGHTER =
		{
			TOOFAR = "这般身慢…罢了。",		--目标逃走了
		},
		-- 将船停入修船厂(单机版海难DLC)
		SAIL =
		{
			REPAIR = "万事皆备，只待东风。",-- 船的状态完好
		},
		--划船失败
		ROW_FAIL =
		{
			BAD_TIMING0 = "太快了。",				-- 第1次
			BAD_TIMING1 = "这瀚海，还真是难缠。",	-- 第2次
			BAD_TIMING2 = "我应该再熟悉熟悉节奏。",	-- 第3次
		},
		--收帆失败
		LOWER_SAIL_FAIL =
		{
			"哎呦！",						--失败语句一
			"或许我该和渔民学习一下。",		 --失败语句二
			"让我再试试。",					--失败语句三
		},
		-- 给陶轮已有的图纸
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "温故而知新，但是它不需要重新学习这个。",		--给予重复的图纸
		},
		--称重
		COMPARE_WEIGHABLE =
		{
			FISH_TOO_SMALL = "小鳞毋用大秤。",		--鱼太小了
			OVERSIZEDVEGGIES_TOO_SMALL = "小了小了，黍倒是欢喜，粒粒皆辛苦。",		--巨大作物太小了
		},
		-- 耕地研究
		PLANTREGISTRY_RESEARCH_FAIL =
		{
			GENERIC = "不入自梦，安知子之乐？既入子梦，当明子之怨。",		--作物已研究过
			FERTILIZER = "黍每天就在钻研这些吗，傻妹妹。",		--肥料已研究过
		},
		-- 水壶在海里灌水
		FILL_OCEAN =
		{
			UNSUITABLE_FOR_PLANTS = "沧溟咸涩，勿汲洒扫。",		--水壶里不能灌海水
		},
		-- 水壶快没水了
		POUR_WATER =
		{
			OUT_OF_WATER = "得再去盛些水了。",		--水壶倒空了
		},
		POUR_WATER_GROUNDTILE =
		{
			OUT_OF_WATER = "水壶比我的酒坛还空了，总不能拿我的酒浇地吧。",		--水壶没水，无法灌溉耕地
		},
		-- 使用牛玲
		USEITEMON =
		{
			BEEF_BELL_INVALID_TARGET = "只有丰蹄才会跟随这铃声。",		--牛铃只能对牛使用
			BEEF_BELL_ALREADY_USED = "或许我该做个新的铃铛。",		--已经绑定牛的牛铃不能重复绑其他的牛
			BEEF_BELL_HAS_BEEF_ALREADY = "这只丰蹄已经被其他铃铛吸引了。",		--绑定失败，目标牛已经被其他牛铃绑定
		},
		-- 为给有弹窗的建筑物添加材料失败
		CONSTRUCT =
		{
			INUSE = "先来后到。",		--建筑正在使用
			NOTALLOWED = "这种材料不能用在这里。",		--材料不对
			EMPTY = "万丈高楼可不会平地拔起。",		--材料栏无材料
			MISMATCH = "易比我更懂这个，或许我该重新检查一下。",		--建造成果错误（未应用）
			NOTREADY = "这个状态可不行，过会再试试。",	--当前状态无法建造
		},
		--锁定或解锁，用于单机探测杖，联机无效
		UNLOCK =
		{
			WRONGKEY = "这不对。",		--跟基座不匹配
		},
		--解锁克劳斯的赃物袋
		USEKLAUSSACKKEY =
		{
			WRONGKEY = "嗯？不匹配？难道不是这个？",		--使用普通鹿角
			KLAUS = "唉，看来得先解决那位了，他可不会看着我带走这些赃物。",		--克劳斯在场，无法打开
			QUAGMIRE_WRONGKEY = "我得再找一把钥匙。",	--（暴食）
		},

		-- 激活
		ACTIVATE =
		{
			MANNEQUIN_EQUIPSWAPFAILED = "看来这位“朋友”不喜欢这个。",	--与假人互换装备失败
			EMPTY_CATCOONDEN = "这位菲林先生看来还没有自己的珍藏。",		--浣猫窝里没东西
			-- 活动
			-- 浣猫年捉迷藏
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDERS = "小浣猫太少了，只有它们几个可没开始。",		--小浣猫太少，无法捉迷藏
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDING_SPOTS = "栖身处太少了。",		--可藏身物体太少，无法捉迷藏
			KITCOON_HIDEANDSEEK_ONE_GAME_PER_DAY = "偷得半日闲，尽欢毋成瘾。",	--每天只能玩一次捉迷藏
			-- 鸦年华良羽鸦
			HOSTBUSY = "等那位黎博利先生先忙完手头的事吧。",		--良羽鸦正在忙
			CARNIVAL_HOST_HERE = "那位黎博利先生已经在树旁了。",		--良羽鸦已经在树旁
			NOCARNIVAL = "静待再会之时。",		--良羽鸦已离开
			-- 兔人年枕头大战
			PILLOWFIGHT_NO_HANDPILLOW = "有趣的游戏，但我需要一个枕头，或许可以找年做一个。",	--没有枕头，无法进行枕头大战
			-- 暴食
			LOCKED_GATE = "大门锁上了。",		-- 暴食的铁门未开启
			-- 薇洛专属
			NOTMYBERNIE = "不是器伥，也有这么大的脾气，无趣。",	--无法安抚别人的伯尼
			-- 沃特专属
			NOTMERM = "子非鳞，安知鳞？",	--非鱼人不能用食堂海带盘召集鱼人
			NOKELP = "only_used_by_wurt",	--食堂海带盘无海带，不能召集鱼人（沃特专用）
			HASMERMLEADER = "only_used_by_wurt",	--已经有其他玩家用这个海带盘集鱼人了（沃特专用）
		},
		--评鉴皮弗娄牛玩偶（牛年活动）
		APPRAISE =
		{
			NOTNOW = "看来我来的不是时候？",		--评委忙碌中
		},
		--修理雕塑或者化石骨架
		REPAIR =
		{
			WRONGPIECE = "看上去不太对。",		--雕像或化石骨架拼接错误
		},
		-- 领养宠物失败
		BUILD =
		{
			MOUNTED = "还需脚踏实地。",		--骑乘状态下无法领养
			HASPET = "贪心不足，毋要多心。",		--领养失败，已经有一个宠物了
			TICOON = "弱水三千，独饮一瓢，它既随了我也是缘分，就不三心二意了。",	--领养失败，已经有一只大虎了
			BUSY_STATION = "着急不得。",	--锯马工作中需要等待
		},
		-- 使用角色专属道具/放置为建筑型道具
		OPEN_CRAFTING =	
		{
			PROFESSIONALCHEF = "应该让幺弟来试试？",		--非大厨角色使用便携厨具
			SHADOWMAGIC = "奇特的力量，无法掌控。",	--非老麦角色使用暗影秘典
		},
		--进行胡萝卜鼠赛跑
		START_CARRAT_RACE =
		{
			NO_RACERS = "那只奇特的札拉克似乎很害羞。",		--赛场上没有胡萝卜鼠
		},
		--收起便携厨具
		DISMANTLE =
		{
			COOKING = "待人间烟火，许尘世生机。",		--烹饪中
			INUSE = "不要在厨师烹饪的时候打搅他。",		--无法收起，别人在用
			NOTEMPTY = "粒粒皆辛，不可不采，先把食材拿出来。",		--厨具里有东西
		},
		------ 角色专属
        -- 释放技能失败(施法滚轮)
		CASTAOE =
		{
			-- 麦斯威尔
			NO_MAX_SANITY = "only_used_by_waxwell",	--老麦施法时，理智值上限惩罚已到顶（老麦专用）
			-- 薇落(火女)
			NOT_ENOUGH_EMBERS = "only_used_by_willow",	--薇洛施法时，无足够余烬（薇洛专用）
			NO_TARGETS = "only_used_by_willow",	--薇洛释放燃烧术时，周围无目标（薇洛专用）
			CANT_SPELL_MOUNTED = "only_used_by_willow",	--薇洛无法在骑乘时释放月焰（薇洛专用）
			SPELL_ON_COOLDOWN = "only_used_by_willow",	--薇洛要释放的技能正处于冷却中（薇洛专用）
			-- 薇落娜(女工)
			NO_BATTERY = "only_used_by_winona",	--称手遥控器没电了（薇诺娜专用）
			NO_CATAPULTS = "only_used_by_winona",	--遥控范围内没有投石机（薇诺娜专用）
		},
		--找玩具任务（温蒂收服小惊吓）
		BEGIN_QUEST =
		{
			ONEGHOST = "only_used_by_wendy",		--暂无注释
		},
		-- 沃尔夫冈
        -- 使用强大健身房
		ENTER_GYM =
		{
			NOWEIGHT = "only_used_by_wolfang",  -- 没有负重
			UNBALANCED = "only_used_by_wolfang",-- 不平衡(有一侧没有负重？或者负重不均匀)
			ONFIRE = "only_used_by_wolfang",    -- 正在着火
			SMOULDER = "only_used_by_wolfang",  -- 正在闷烧
			HUNGRY = "only_used_by_wolfang",    -- 饥饿值过低
			FULL = "only_used_by_wolfang",      -- 有人在使用
		},
		--读书失败
		READ =
		{
			GENERIC = "等我喝完这杯。",		--通用阅读失败
			-- 《世界鸟类大全》
			NOBIRDS = "千山鸟飞绝。",		--召唤不出鸟
			TOOMANYBIRDS = "众鸟高飞尽，孤云独去闲。",	--附近超过20只鸟则大幅减少读书后的召唤量，以防崩内存
			WAYTOOMANYBIRDS = "百鸟已然尽朝凤。",	--附近超过30只鸟则禁止读书召唤，以防崩内存
			BIRDSBLOCKED = "这是孤独的战场，生灵勿近。",			  -- 瓦格斯塔夫竞技场内
			DEADBIRDS = "月雹似刀，屠尽千鸟，已然无归去。",				  -- 月雹期间
			-- 《垂钓者指南》
			NOWATERNEARBY = "既无深潭，何觅潜鳞。",	--附近没有水，无法生成鱼群
			-- 《意念控火术》
			NOFIRES ="无烛可纵，无焰可熄。",	--附近没有火焰
			-- 《应用造林学》
			NOSILVICULTURE = "无木难支，何以令发。",	--附近没有树木或树精
			-- 《园艺学简编版》/《园艺学拓展版》
			NOHORTICULTURE = "附近没有作物，或许我应该去黍的农田试试？",	--附近没有作物
			-- 《触手的召唤》
			NOTENTACLEGROUND = "地表太坚硬了。",	--附近没有可生成触手的地形
			-- 《睡前故事》
			NOSLEEPTARGETS = "看来没有人想和我一同梦遍大千。",	--附近没有可以睡眠的生物
			-- 《养蜂笔记》
			TOOMANYBEES = "太多了。",	--嗡嗡蜜蜂数量达到上限
			-- 《月之魔典》
			NOMOONINCAVES = "潜窟何以号苍月？",	--洞穴里无法改变月相
			ALREADYFULLMOON = "已是望月。二哥倒是挺会给自己取名。",	--已经是满月了
		},
		-- 薇格弗德(女武神)唱战歌失败
		SING_FAIL =
		{
			SAMESONG = "only_used_by_wathgrithr",
		},
		-- 沃尔特(童子军)
		-- 讲故事
		TELLSTORY =
		{
			GENERIC = "only_used_by_walter",		--暂无注释
			NOT_NIGHT = "only_used_by_walter",		--暂无注释
			NO_FIRE = "only_used_by_walter",		--暂无注释
		},
		-- 改装弹弓失败
		MODSLINGSHOT =
		{
			NOSLINGSHOT = "only_used_by_walter",     -- 沃尔特尝试改装弹弓但未携带弹弓
		},
		-- 扑捉动作失败
		POUNCECAPTURE =
		{
			MISSED = "让它逃得一劫！",                 -- 扑捉技能因目标移动失败
		},
		-- 俯冲抓取失败
		DIVEGRAB =
		{
			MISSED = "让它逃得一劫！",                 -- 俯冲抓取因目标移动失败
		},
		-- WX-78
		-- WX-78插入电路
		APPLYMODULE =
		{
			COOLDOWN = "only_used_by_wx78",		--插拔电路冷却时间未到
			NOTENOUGHSLOTS = "only_used_by_wx78",	--剩下的插槽不够
		},
		-- WX-78拔出电路
		REMOVEMODULES =
		{
			NO_MODULES = "only_used_by_wx78",	--没有电路
		},
		-- WX-78充能
		CHARGE_FROM =
		{
			NOT_ENOUGH_CHARGE = "only_used_by_wx78",	--电力不够
			CHARGE_FULL = "only_used_by_wx78",	--自身电池槽已满
		},
		-- 非机器人角色获取生物扫描仪数据
		HARVEST =
		{
			DOER_ISNT_MODULE_OWNER = "无趣，留给需要它人吧。",	--非机器人角色获取生物扫描仪数据
		},
		-- 麦斯威尔
		CAST_SPELLBOOK =
		{
			NO_TOPHAT = "only_used_by_waxwell",	--老麦施法时，没有高礼帽可变为魔术师高礼帽（老麦专用）
		},
		-- 沃特(小鱼人)
		CASTSPELL =
		{
			TERRAFORM_TOO_SOON = "only_used_by_wurt",	--投泥带仍处在冷却中（沃特专用）
		},
		-- 韦伯(蜘蛛人)
		-- 使用韦伯口哨召集蜘蛛
		HERD_FOLLOWERS =
		{
			WEBBERONLY = "不通言语，或许应该让那位叫韦伯的孩子试试。",		--不是韦伯，无法召集蜘蛛
		},
		-- 装饰蜘蛛巢
		BEDAZZLE =
		{
			BURNING = "only_used_by_webber",-- 蜘蛛巢正在燃烧
			BURNT = "only_used_by_webber",  -- 蜘蛛巢烧毁了
			FROZEN = "only_used_by_webber", -- 蜘蛛巢被冰冻了
			ALREADY_BEDAZZLED = "only_used_by_webber",-- 蜘蛛巢已经装饰过了
		},
		-- 升级蜘蛛巢
		UPGRADE = 
		{
			BEDAZZLED = "only_used_by_webber",		--无法给已装饰过的蜘蛛巢升级（韦伯专用）
		},
		-- 旺达
		-- 使用怀表
		CAST_POCKETWATCH =
		{
			GENERIC = "only_used_by_wanda",		--暂无注释
			REVIVE_FAILED = "only_used_by_wanda",		--暂无注释
			WARP_NO_POINTS_LEFT = "only_used_by_wanda",		--暂无注释
			SHARD_UNAVAILABLE = "only_used_by_wanda",		--暂无注释
		},
		--拆解怀表
		DISMANTLE_POCKETWATCH =
		{
			ONCOOLDOWN = "only_used_by_wanda",		-- 怀表冷却中，无法拆解
		},
		-- 薇洛娜(女工)
		-- 使用玫瑰色眼镜检查
		LOOKAT =
		{
			ROSEGLASSES_INVALID = "黑魔法也一无所获。",          -- 检查无结果
			ROSEGLASSES_COOLDOWN = "哪怕是黑魔法也不能如此滥用。",-- 检查冷却中
			ROSEGLASSES_DISMISS = "消散吧，等待我的下次征召。",   -- 检查黑暗痕迹使其消失
			ROSEGLASSES_STUMPED = "我还没有掌握这种法术……",      -- 检查天赋不够
		},
		-- 传送伞
		REMOTE_TELEPORT =
		{
			NOSKILL = "only_used_by_winona",-- 没有对应技能无法使用传送伞
			NODEST = "only_used_by_winona",	-- 激活传送伞无传输站
		},
		-- 温蒂
		-- 温蒂尝试令阿比盖尔变身失败
		MUTATE =
		{
			NOGHOST = "only_used_by_wendy",          -- 尝试变异但周围无可用幽灵
			NONEWMOON = "only_used_by_wendy",        -- 尝试新月变异但非新月阶段
			NOFULLMOON = "only_used_by_wendy",       -- 尝试满月变异但非满月阶段
			NOTNIGHT = "only_used_by_wendy",         -- 尝试夜间变异但当前是白天
			CAVE = "only_used_by_wendy",             -- 在洞穴中尝试依赖月光的变异
		},
		-- 皮弗娄牛年活动相关
	    -- 选择参与牛
		MARK =
		{
			ALREADY_MARKED = "我已经选好了。",		--已经选好牛，不能再选别的
			NOT_PARTICIPANT = "我没有选手参赛。",		--没有牛
		},
		--开始评选皮弗娄牛
		YOTB_STARTCONTEST =
		{
			DOESNTWORK = "无人评选，这场比赛毫无意义，等评委来吧。",		--没有评委，无法进行比赛
			ALREADYACTIVE = "等他忙完吧。",		--评委正在进行其他比赛
		},
		--学习制作皮弗娄牛礼服样式
		YOTB_UNLOCKSKIN =
		{
			ALREADYKNOWN = "很熟悉，我已经掌握了。",-- 解锁已知皮肤
		},
		-- 嘉年华鸟鸟吃虫虫游戏，喂鸟
		CARNIVALGAME_FEED =
		{
			TOO_LATE = "这般身慢，何以成事！",		--鸟的持续时间过了，缩回去了
		},
		-- 钓鱼失败
		FISH_OCEAN =
		{
			TOODEEP = "沪渎需得妙杆。",	-- 拿普通鱼竿去深海钓鱼
		},
		OCEAN_FISHING_POND =
		{
			WRONGGEAR = "大材小用。",-- 拿深海鱼竿去普通的池子里钓鱼
		},
		-- 水獭窝
		PICK =
		{
			NOTHING_INSIDE = "看来这些水上掠夺者还没有找到东西。",	--水獭掠夺者窝点里没东西
		},
		-- 蚊血注射液
		HEAL =
		{
			NOT_MERM = "或许应该对泥沼那边的鳞类试试？",	--蚊血注射液只对鱼人有效
		},
		-- 对温泉使用沐浴球失败
		BATHBOMB =
		{
			GLASSED = "月华已结，予之无用。",	--温泉已凝结为玻璃
			ALREADY_BOMBED = "水温正好。",--温泉已投入浴盐球
		},
		-- 尝试泡温泉失败
		SOAKIN =
		{
			NOSPACE = "人满为患。", -- 已经满员了
		},
		-- 雕刻南瓜失败
		CARVEPUMPKIN =
		{
			INUSE   = "已为他人物。",          -- 已经有其他玩家正在雕刻
			BURNING = "毋为刀裁，止余烈火。",              -- 南瓜着火了
		},
		-- 装饰雪人失败
		DECORATESNOWMAN =
		{
			INUSE = "已为他人物。",          -- 已经有其他玩家正在装饰雪人
			HASHAT = "这又不是帽子工厂。", 				-- 雪人头上有帽子遮挡装饰位置
			STACKEDTOOHIGH = "身负千钧，毋添烦缺。", -- 雪人堆叠部件超出上限
			MELTING = "终似黄粱梦，春来献身归。",					-- 雪人处于融化状态
		},
	},
------ 常见通用台词 --------------------------------------------------------------------------------------
	ANNOUNCE_DESPAWN = "这场千秋大梦，本就该醒了。",		--天体传送门处换人
	ACTIONFAIL_GENERIC = "不对，不对。",		--通用动作失败默认设置
	INSPECTSELF = "我即我，我身即逍遥。",		-- 物品名:"检查自己"
	ANNOUNCE_ADVENTUREFAIL = "这次不太顺利。我必须再试一次。",		--动作失败（废案）
	-- 制作失败
	ANNOUNCE_CANNOT_BUILD =
	{
		NO_INGREDIENTS = "还缺少一些材料。",	--材料不足
		NO_TECH = "或许我需要一个更复杂的机器。",	--科技不够
		NO_STATION = "我需要在一个更精密的机器旁边才能制作。",	--不在科技建筑旁边
	},
	ANNOUNCE_CRAFTING_FAIL = "缺少一些关键成分。",--制作时材料不足(未应用)
	-- 亮度变化
	ANNOUNCE_DUSK = "日色已昏，云烧得好旺！",		--进入黄昏
	ANNOUNCE_ENTER_DARK = "月黑风高夜。",		--进入黑暗
	ANNOUNCE_ENTER_LIGHT = "光芒，灿若黄金。",		--进入光源
	-- 玩家死亡和鬼魂
	ANNOUNCE_BECOMEGHOST = "…………",		--变成鬼魂检查物品
	ANNOUNCE_GHOSTDRAIN = "多了一个幽魂…麻烦了...",		--队友死亡变成鬼魂掉san
	-- 特殊检查情况
	DESCRIBE_GENERIC = "我在梦里见过这个，是什么呢？",		--检查物品描述的缺省值
	DESCRIBE_TOODARK = "长夜苦暗。",		--黑暗中没有视野
	DESCRIBE_SMOLDERING = "一场正在酝酿的火灾…也许还能阻止它。",		--检查闷烧冒烟的东西
	ANNOUNCE_BURNT = "好烫！",		--扑灭冒烟的东西时被烫到
	-- 自身处于特殊状态
	ANNOUNCE_INV_FULL = "太多无用的东西，只会徒增烦恼，该抛弃一些东西了。",		--身上的物品满了
	ANNOUNCE_COLD = "天寒色青苍，北风叫枯桑。",		--过冷
	ANNOUNCE_HOT = "永日不可暮，炎真毒我肠。",		--过热
	ANNOUNCE_HUNGRY = "饿了，尝尝这人间的烟火，滋味如何。",		--饥饿
	ANNOUNCE_COZY_SLEEP = "八千年为春，八千年为冬，梦见的那些，也不过短短几个秋，如此罢了。",	--睡了个好觉后醒来
	ANNOUNCE_KNOCKEDOUT = "又是一场千秋大梦。",		--被催眠后醒来
	ANNOUNCE_TOWNPORTALTELEPORT = "有点赶时间，借过。",		--强征传送塔传送
	ANNOUNCE_HERMITCRAB_SHELL_BADTELEPORTPOINT = "也许该换个位置试试？", 	  -- 使用搬运海螺传送失败
	ANNOUNCE_HERMITCRAB_SHELL_ARRIVE           = "缩地成寸。", -- 使用搬运海螺传送
	ANNOUNCE_WORTOX_REVIVER_FAILTELEPORT = "咦，失效了。", -- 使用双尾心传送失败
	ANNOUNCE_CHAIR_ON_FIRE = "诶呦，好烫。",	--坐着的椅子着火
	-- 潮湿状态
	ANNOUNCE_DAMP = "微雨池塘见，好风襟袖知。",		--潮湿（1级）
	ANNOUNCE_WET = "细雨湿衣看不见，闲花落地听无声。",		--潮湿（2级）
	ANNOUNCE_WETTER = "漫漫水路！",		--潮湿（3级）
	ANNOUNCE_SOAKED = "或许我该在亭子里喝点酒睡一觉，现在身上湿透了。",		--潮湿（4级）
	-- 进食动作
	ANNOUNCE_EAT =
	{
		GENERIC = "人间有味是清欢！",		--吃新鲜食物
		PAINFUL = "下次让幺弟改进下配方吧，可惜了这些食材。",		--吃掉血食物
		SPOILED = "浪费粮食可耻，但是这样的食物真的还能吃吗…",		--吃红色食物及腐烂食物
		STALE = "朱门酒肉臭，或许一次性做太多食物不是一个好主意。",		--吃黄色食物
		INVALID = "下不去口…",		--不可食用
		YUCKY = "罗德岛的那只黄色佩洛也不会吃这个东西吧。",		--拒绝食用恶心的东西（比如永恒的水果蛋糕）

		-- 沃利(大厨)专属台词
		COOKED = "值得褒奖的厨艺。",-- 进食料理
		DRIED = "丰盛而美味。", -- 疑似进食肉干？
		PREPARED = "值得欣赏的美味。",-- 暂时未知
		RAW = "灾难性的口感！",   -- 进食潮湿食物
		SAME_OLD_1 = "only_used_by_warly",-- 食物记忆1次
		SAME_OLD_2 = "only_used_by_warly",-- 食物记忆2次
		SAME_OLD_3 = "only_used_by_warly",-- 食物记忆3次
		SAME_OLD_4 = "only_used_by_warly",-- 食物记忆4次
		SAME_OLD_5 = "only_used_by_warly",-- 食物记忆5次
		TASTY = "味道不错。",     -- 吃不属于上述类型的食物
	},
	-- 搬运重物(雕像/可疑的大理石/天体祭坛部件等)
	ANNOUNCE_ENCUMBERED =
	{
		"负重前行...",		--搬运重物
		"清平...过来搭把手...",		--搬运重物
		"逍遥...来帮个忙...",		--搬运重物
		"弦惊...我觉得你能背的动...",		--搬运重物		
		"呼...",		--搬运重物
		"好风...凭借力...送我...呼...好累...",		--搬运重物
	},
	-- 挖开天体祭坛部件(吸引人的结构)
	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "里面有东西。",		--开始挖天体底座
		GLASS_LOW = "快挖出来了。",		--天体底座挖到一半
		GLASS_REVEAL = "重见天日！",		--挖出天体底座
		IDOL_MED = "里面有东西。",		--开始挖天体雕像
		IDOL_LOW = "快挖出来了。",		--天体雕像挖到一半
		IDOL_REVEAL = "重见天日！",		--挖出天体雕像
		SEED_MED = "里面有东西。",		--开始挖天体宝球
		SEED_LOW = "快挖出来了。",		--天体宝球挖到一半
		SEED_REVEAL = "重见天日！",		--挖出天体宝球
	},
	-- 道具损坏、脱手、错误应用
	ANNOUNCE_TOOL_SLIP = "诶呦，手好滑。",		--工具滑出
	ANNOUNCE_TOOL_TOOWEAK = "感觉比镇抚木还硬！或许我得换个工具。",	--没有强力开采的工具试图敲绝望石柱、开采纯粹辉煌和绝望石
	ANNOUNCE_COMPASS_OUT = "这个指南针已经坏了。",		--指南针损坏
	ANNOUNCE_TORCH_OUT = "或许我该再做一根火把？",		--火把用完了
	ANNOUNCE_THURIBLE_OUT = "它在渴望燃料。",		--暗影香炉燃尽
	ANNOUNCE_BOOK_MOON_DAYTIME = "明月圆缺，听吾号令。",	--白天读书改变月相
	ANNOUNCE_FAN_OUT = "随风消逝。",		--小风车停了
	ANNOUNCE_GATHER_MERM = "子非鳞，安知鳞。",	--食堂海带盘处召集鱼人
	ANNOUNCE_SACREDCHEST_YES = "有趣，有趣，让我看看这些小家伙又会给我什么。",		--远古宝箱放入正确物品成功解谜
	ANNOUNCE_SACREDCHEST_NO = "嗯？让我再试试。",		--远古宝箱解谜失败
	ANNOUNCE_RABBITKINGHORN_BADSPAWNPOINT = "它们可不会在水里面打洞。",	--玩家不在陆地上，无法召唤出便携式巢穴

	ANNOUNCE_SHELTER = "前林夏雨歇，为我生凉风。",		--下雨天躲树下
	ANNOUNCE_WORMHOLE = "呼，至少我抵达了目的地？",		--虫洞旅行
	ANNOUNCE_CANFIX = "\n我应该能修好它，可惜易工部不在，不然他修起来更快。",		--目标可以修理
	ANNOUNCE_PREFALLINVOID = "诶呦，差点从桥上掉下去。",	--吊桥正在裂开，即将塌掉
	ANNOUNCE_OTTERBOAT_OUTOFSHALLOWS = "它们的窝点无法走的更远。",	--水獭掠夺者窝点无法在深海航行
	ANNOUNCE_OTTERBOAT_DENBROKEN = "直取黄龙！或许我该考虑怎么回到岸上了……",	--水獭掠夺者窝点毁掉后船体开始损坏
	
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "百丈狂沙吹雪，咫尺惊雷连云！",		--绝缘或者未被闪电击中
	-- 翻脚印狩猎
	ANNOUNCE_HUNT_BEAST_NEARBY = "它就在附近了，先前的大炎，也是这般狩猎我们吗？",		--即将找到野兽
	ANNOUNCE_HUNT_LOST_TRAIL = "身慢了，它逃掉了。",		--脚印消失，追丢野兽
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "好一场雨，就当是天意吧。",		--脚印消失，追丢野兽（潮湿天气）
	-- 暴食
	QUAGMIRE_ANNOUNCE_NOTRECIPE = "这些配料做不成食物。",	--（熔炉）
	QUAGMIRE_ANNOUNCE_MEALBURNT = "烧太长时间了。",	--（熔炉）
	QUAGMIRE_ANNOUNCE_LOSE = "我有种不好的预感。",	--（熔炉）
	QUAGMIRE_ANNOUNCE_WIN = "该走了！",	--（熔炉）
	-- 对头戴蜂王冠的玩家
	ANNOUNCE_ROYALTY =
	{
		"你得到了认可。",		--向带着蜂王帽的队友鞠躬
		"欲戴王冠，必承其重。",		--向带着蜂王帽的队友鞠躬
	},
	-- 对头戴蜂王冠小丑帽皮肤的玩家
    ANNOUNCE_ROYALTY_JOKER =
    {
        "弄臣。",
        "呵……",
    },
------ 预警、受伤与BOSS战相关
	ANNOUNCE_CHARLIE = "夜雨浇熄，往事残烛。",		--查理即将攻击
	ANNOUNCE_CHARLIE_ATTACK = "夜袭！燃火！",		--被查理攻击
	ANNOUNCE_HOUNDS = "看来有不速之客来找我，罢了，送它们一程。",		--猎犬袭击即将到来
	ANNOUNCE_WORMS = "这群很像土龙的爬虫还真是锲而不舍。",		--蠕虫袭击即将到来	
	ANNOUNCE_PIRATES_ARRIVE = "大哥当年剿灭江南水患，是怎么样的过程？现在我可能也要体验一番了。",	--猴子海盗来临
	ANNOUNCE_ACIDBATS = "‌伏翼昏飞急，营营定苦饥。又有一些不速之客了。",	--酸雨蝙蝠袭击即将到来
	ANNOUNCE_DEERCLOPS = "这么大动静，兴许是我的同族？",		--boss(巨鹿、熊獾)来袭
	ANNOUNCE_WORMS_BOSS = "有点难缠了，这只大的可不好解决。",	--大蠕虫袭击即将到来
	
	ANNOUNCE_MOUNT_LOWHEALTH = "万物有灵，它应当被照料。",		--骑乘的牛血量过低
	ANNOUNCE_THORNS = "锐利的植物，还是离远一点。",		--玫瑰、仙人掌、荆棘扎手
	ANNOUNCE_TRAP_WENT_OFF = "诶呦，我该注意点的。",		--触发陷阱（例如冬季陷阱）
	ANNOUNCE_BOOMERANG = "生疏了，这般手慢，怕是会被大哥笑话。",		--没接住回旋镖
	ANNOUNCE_MOSQUITOS = "贪得无厌！",		--被蚊子攻击
	ANNOUNCE_BEES = "莫予荓蜂，自求辛螫。好在有些防护措施。",		--戴养蜂帽被蜜蜂蛰
	ANNOUNCE_PECKED = "养不熟的白眼狼。",		--被小高脚鸟啄
	--  兔王
	ANNOUNCE_RABBITKING_AGGRESSIVE = "看来这位君王不欢迎我。",	--召唤出暴戾兔王
	ANNOUNCE_RABBITKING_PASSIVE = "是一只卡特斯君王。",	--召唤出和善兔王
	ANNOUNCE_RABBITKING_LUCKY = "奇怪的卡特斯",	--机缘兔子出现
	ANNOUNCE_RABBITKING_LUCKYCAUGHT = "抓到你啦！",	--抓到机缘兔子
	--  克劳斯
	ANNOUNCE_KLAUS_ENRAGE = "他好像很愤怒。",		--杀死了鹿后克劳斯被激怒
	ANNOUNCE_KLAUS_UNCHAINED = "你也寻得它了，也罢，再战第二合。",		--克劳斯第一次死亡后复活
	ANNOUNCE_KLAUS_CALLFORHELP = "战场是不会讲理的，对你也是，对我也是。",		--克劳斯召唤小偷
	--  织影者
	ANNOUNCE_SNARED = "折骨做笔，圈地织笼，是我大意了。",		--被远古织影者的骨笼困住
	ANNOUNCE_REPELLED = "没有无懈可击的防御，肯定在哪里有破绽。",		--织影者进入保护状态
	-- 中庭刷新
	ANNOUNCE_ATRIUM_DESTABILIZING =
	{
		"该走了。",		--中庭击杀织影者后开始震动，即将刷新
		"希望你在梦里能对自己的罪孽释怀。",		--中庭击杀织影者后开始震动，即将刷新
		"这里不安全。",		--中庭击杀织影者后开始震动，即将刷新
	},
	ANNOUNCE_RUINS_RESET = "已有的事，后必再有；已行的事，后必再行。",		--地下重置
	
	ANNOUNCE_EXIT_GELBLOB = "腌臜！我应该离那东西远些的！",	--被恶液吞入后挣脱出来
	-- 蜈蚣墨荒
	ANNOUNCE_WEAPON_TOOWEAK = "好生坚硬的甲！", -- 需要强力武器(攻击蜈蚣墨荒被弹开)
	ANNOUNCE_MUTATED_BUZZARD_ARRIVAL = "死亡在空中盘旋。", -- 变异秃鹫生成并开始盘旋玩家
	-- 被蛇墨荒/狞笑在隐身形态下攻击
	ANNOUNCE_SHADOWTHRALL_STEALTH = "出其不意，攻其不备，好谋算。",	--被苦笑暗影偷袭
	
	ANNOUNCE_TOADESCAPING = "这只大蟾蜍对我没有兴趣了。",		--蟾蜍正在逃跑
	ANNOUNCE_TOADESCAPED = "这只蟾蜍走了。",		--蟾蜍逃走了

	ANNOUNCE_QUAKE = "不安分的家伙，希望这洞穴足够结实。",		--洞穴内地震
	ANNOUNCE_CAVEIN = "不安分的家伙，希望这洞穴足够结实。",		--洞穴内蚁狮地震
	-- 蚁狮地震
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"地面在晃动，又免不了一阵天旋地转了。",		--蚁狮地震
		"嗯？地震！",		--蚁狮地震
		"巨灵怒劈太华来，坤舆斮破声如雷。",		--蚁狮地震
	},
	-- 蚁狮互动
	ANNOUNCE_ANTLION_TRIBUTE =
	{
		"你好，奇特的沙漠之王。",		--向蚁狮致敬
		"做场交易如何？",		--给蚁狮上供
		"成交！",		--给蚁狮上供
	},
	ANNOUNCE_FLARE_SEEN = "是烟火？还是信号？",		--队友发出信号弹
	ANNOUNCE_MEGA_FLARE_SEEN = "所或许会有怪物追寻它找过来。",	--发出敌对信号弹
	ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "海怪！",		--海怪出现（单机海难）
	-- 进入战斗状态
	BATTLECRY =
	{
		GENERIC = 
		{
			--通用战斗
			"上兵伐谋，我自有计破敌。",
			"其次伐兵，我去斩了来将。",
			"酒在杯中，剑在匣内，别叫我失了兴致。",		
		},
		PIG =
		{
			--与猪人战斗（疯猪除外）
			"擂鼓，进军！",
			"青锋既成笔，何叹墨色朱？",
			"折戟沉沙，壮志未酬！",
		},
		PREY = 
		{
			--与小型生物战斗（例如兔子，青蛙，鼹鼠））
			"杀鸡焉用牛刀！",
			"十步一杀，千里不留行！",
			"折戟沉沙，壮志未酬！",
		},
		SPIDER = "十步一杀，千里不留行！",		--与蜘蛛战斗
		SPIDER_WARRIOR = "青锋既成笔，何叹墨色朱？",		--与蜘蛛战士战斗
		DEER = "奉时辰牡，辰牡孔硕！",		--与无眼鹿战斗
	},
	-- 脱离战斗
	COMBAT_QUIT =
	{
		GENERIC = "志得意满，如杯满盈。",		--停止攻击
		PIG = "偃旗息鼓。",		--停止攻击猪人
		PREY = "小试牛刀。",		--停止攻击小型生物
		SPIDER = "事了拂衣去。",		--停止攻击蜘蛛
		SPIDER_WARRIOR = "曲罢，兵燹尽。",		--停止攻击蜘蛛战士
	},
	ANNOUNCE_OFF_SCRIPT = "台上一分钟，台下十年功，回去再练练吧。",	--表演错误
	-- 裂隙扩张
	ANNOUNCE_LUNAR_RIFT_MAX = "月神已经在更深的影响这片大地了。",	--远处月亮裂隙扩张到最大时
	ANNOUNCE_SHADOW_RIFT_MAX = "暗影已经在更深的影响这片大地了。",	--远处暗影裂隙扩张到最大时
	ANNOUNCE_SCRAPBOOK_FULL = "已了然于心。",	--图鉴上已有该条目
	-- 翻脚印相关
	DIRTPILE = "像是某种大型动物的踪迹。",		-- 可疑的土堆（翻大象）
	ANIMAL_TRACK = "野兽的踪迹，跟着它能找到一只野兽。",	-- 动物足迹
	ANNOUNCE_HUNT_START_FORK = "螳螂捕蝉，黄雀在后。",	--摸脚印选带狗牙土堆
	ANNOUNCE_HUNT_SUCCESSFUL_FORK = "好运眷顾，或许我该饮一壶？",	--摸脚印结果导向丰盛收获
	ANNOUNCE_HUNT_WRONG_FORK = "引君入瓮？呵。",	--摸脚印结果导向陷阱
	ANNOUNCE_HUNT_AVOID_FORK = "还不错。",	--摸脚印选普通土堆
	-- 和恐怖之眼战斗
	ANNOUNCE_EYEOFTERROR_ARRIVE = "窥伺者，既来之休走之。",	-- 新的眼球出现
	ANNOUNCE_EYEOFTERROR_FLYBACK = "偷窥者又回来了。",				-- 没打完的眼球再次出现
	ANNOUNCE_EYEOFTERROR_FLYAWAY = "扰我幽梦，罢了，下次再收拾你。",	-- 白天眼球逃走
	ANNOUNCE_LUNARGUARDIAN_INCOMING = "没完没了？", -- 月之守护者生成并向玩家靠近
	 -- 获得buff
	ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK	= "五雷正法？好像又不是。",		--获得料理buff：带电攻击
	ANNOUNCE_ATTACH_BUFF_ATTACK			= "王兴于师，修我戈矛。",		--获得料理buff：增加伤害
	ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "岂曰无衣，与子同袍。",		--获得料理buff：增加防御
	ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "百尺竿头须进步，十方世界是全身。",		--获得料理buff：工作效率提高
	ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "一蓑烟雨任平生。",		--获得料理buff：防潮湿
	ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "旅馆寒灯独不眠，客心何事转凄然。",		--获得料理buff：睡眠抗性
	-- 温蒂草药
	ANNOUNCE_ELIXIR_BOOSTED      = "静以修身、俭以养。",      -- 回血类药剂
	ANNOUNCE_ELIXIR_GHOSTVISION  = "觑尽红尘雾，犹怜天下暮。", -- 饮用夜影万金油(幽灵夜视)
	ANNOUNCE_ELIXIR_PLAYER_SPEED = "所用皆鹰腾，破敌过箭疾。", -- 饮用强健精油(减少减速效果)
	ANNOUNCE_ELIXIR_TOO_SUPER    = "药性过猛，不宜饮用。", -- 尝试使用位面药剂
	-- 失去buff
	ANNOUNCE_DETACH_BUFF_ELECTRICATTACK	= "电消云散。",		--料理buff消失：带电攻击
	ANNOUNCE_DETACH_BUFF_ATTACK			= "偃旗息鼓。",		--料理buff消失：增加伤害
	ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "战机转瞬即逝。",		--料理buff消失：增加防御
	ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "动作变慢了。",		--料理buff消失：工作效率提高
	ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "得小心我的诗被打湿。",		--料理buff消失：防潮湿
	ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "醉后不知天在水，满船清梦压星河。",		--料理buff消失：睡眠抗性
	ANNOUNCE_HEALINGSALVE_ACIDBUFF_DONE = "或许我得再涂点。",	--药膏的防酸雨buff结束
	-- 因为处于危险(战斗状态)而无法行动/交互(例如睡觉、收在线礼物)
	ANNOUNCE_NOWARDROBEONFIRE = "绫罗绸缎，一夕烬尽，先救火吧。",		--使用衣柜或皮弗娄牛美妆台时着火了
	ANNOUNCE_NODANGERGIFT = "我得在安全的地方拆礼物。",		--周围有危险的情况下打开礼物
	ANNOUNCE_NOMOUNTEDGIFT = "拆礼物可得脚踏实地啊。",		--骑牛的时候打开礼物
	ANNOUNCE_NODANGERSLEEP = "扰我幽梦，先收拾收拾你们。",		--周围危险，不能睡觉
	-- 无法入睡状态
	-- 有关帐篷
	ANNOUNCE_NODAYSLEEP = "莫向光阴惰寸功。",		--白天睡帐篷
	ANNOUNCE_NODAYSLEEP_CAVE = "日长睡起无情思，闲看儿童捉柳花。",		--洞穴里白天睡帐篷
	ANNOUNCE_NOHUNGERSLEEP = "或许我该找幺弟蹭一桌饭？",		--饿了无法睡觉
	ANNOUNCE_NOSLEEPONFIRE = "在灰烬和烟火中入梦可不是一个好主意。",		--帐篷着火无法睡觉
	ANNOUNCE_NOSLEEPHASPERMANENTLIGHT = "only_used_by_wx78",	--机器人安装发光模块时无法睡觉
	ANNOUNCE_NODANGERSIESTA = "……扰我清梦。",		--周围危险，不能午睡
	-- 有关遮阳棚
	ANNOUNCE_NONIGHTSIESTA = "睡在这里会着凉的。",		--夜晚睡凉棚
	ANNOUNCE_NONIGHTSIESTA_CAVE = "或许我该在一个更安全的地方睡觉。",		--在洞穴里夜晚睡凉棚
	ANNOUNCE_NOHUNGERSIESTA = "吃点东西才有力气做白日梦！",		--饱食度不足无法午睡
	ANNOUNCE_NODANGERAFK = "……扰我清梦。",    -- (未知？疑似被怪物打扰无法午睡)

------ 耕作与农艺相关------------------------------------------------------------------------------------
	ANNOUNCE_SNARED_IVY = "在花园种这些花还是太危险了…",		--被刺针旋花的藤蔓困住
------ 火荨麻buff
	-- 得到buff
	ANNOUNCE_FIRENETTLE_TOXIN =
	{
		"比烧刀子还烈！",		--吃下火荨麻后急剧升温
		"哎哟，太热了！",		--吃下火荨麻后急剧升温
	},
	-- buff结束
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "看来火荨麻不适合酿酒。",		--火荨麻升温效果结束
	-- 检查农作物对话
	DESCRIBE_PLANTHAPPY = "看起来它很开心。",		--作物压力值低
	DESCRIBE_PLANTSTRESSED = "它有些暴躁。",		--作物压力值中等(没有使用耕作先驱帽)
	DESCRIBE_PLANTVERYSTRESSED = "它的压力特别大。",		--作物压力值高(没有使用耕作先驱帽)
	-- 有耕作先驱帽时显示具体压力来源
	DESCRIBE_PLANTSTRESSORKILLJOYS = "杂草在挤压它的生长空间。",		--作物周围有杂草
	DESCRIBE_PLANTSTRESSORFAMILY = "独木难支。",		--作物未形成家族
	DESCRIBE_PLANTSTRESSOROVERCROWDING = "太拥挤了。",		--作物太挤
	DESCRIBE_PLANTSTRESSORSEASON = "它不适合这个季节。",		--作物不适合当前季节
	DESCRIBE_PLANTSTRESSORMOISTURE = "诶呀，忘了浇水了。",		--作物缺水
	DESCRIBE_PLANTSTRESSORNUTRIENTS = "土地有些贫瘠了。",		--作物缺肥料
	DESCRIBE_PLANTSTRESSORHAPPINESS = "它想听别人说说话。",		--作物需要交流

	ANNOUNCE_INSUFFICIENTFERTILIZER = "这片大地缺少生机，祂需要补充营养。",		--土地肥力不足
	ANNOUNCE_PLANT_RESEARCHED =
	{
		"一株全新的植物！",		--研究新的作物
	},
	ANNOUNCE_FERTILIZER_RESEARCHED = "黍一直在和这东西打交道吗。",		--研究新的肥料
	ANNOUNCE_PLANT_RANDOMSEED = "让它先发芽。",		--研究普通种子
	-- 沃姆伍德专属：铲除植物时的愧疚台词
    ANNOUNCE_KILLEDPLANT =
    {
        "它不该呆在这。",
        "一次干净利落的处刑。",
        "不知道那块活的绿宝石对此有何看法。",
    },
	-- 沃姆伍德专属：对话植物
    ANNOUNCE_GROWPLANT =
    {
        "快长大吧，我等着收获。",
        "有人比我更适合做这个。",
        "快长吧，我要等不耐烦了。",
    },
	-- 沃姆伍德专属：开花
    ANNOUNCE_BLOOMING =
    {
        "感觉开花了。",
    },
	-- 照料植物时
	ANNOUNCE_TALK_TO_PLANTS =
	{
		"欣欣向荣，生生不息！",
		"春种一粒粟，秋收万颗子。",
		"晨兴理荒秽，带月荷锄归。",
		"晓耕翻露草，夜榜响溪石。",	
		"彼黍离离，彼稷之穗。",
	},
------ 航海与钓鱼相关-------------------------------------------------------------------------------------
	ANNOUNCE_WASHED_ASHORE = "不善水战，是我失策了…",		--落水后飘回岸上
	ANNOUNCE_FLOATER_HELD   = "……至少……不算完败……", -- 落水后依靠个人漂浮装置浮起
	ANNOUNCE_FLOATER_LETGO  = "……随波……逐流……", -- 放弃个人漂浮装置选择落水
	-- 海钓失败
	ANNOUNCE_OCEANFISHING_LINESNAP = "白忙活一场。",		--海钓竿断线
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "就是现在。",		--咬钩的海鱼不扯线
	ANNOUNCE_OCEANFISHING_GOTAWAY = "可惜。",		--咬钩的海鱼逃跑了
	ANNOUNCE_OCEANFISHING_BADCAST = "或许我该再用点力。",		--海钓竿甩线太近
	-- 海钓等待上钩时闲聊
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE =
	{
		"耐心。",
		"星级钓不得大鳞",
		"也许该换个鱼多的地方钓鳞。",
		"这附近好像没有鳞？",
		"子非鳞，安知鳞？",	
	},
	-- 给鱼称重
	ANNOUNCE_WEIGHT = "重量：{weight}",		--称重普通海鱼
	ANNOUNCE_WEIGHT_HEAVY  = "重量: {weight}\n重量级钓手！",		--称重重量级海鱼
	-- 夹夹绞盘
	ANNOUNCE_WINCH_CLAW_MISS = "好像没对准。",		--夹夹绞盘没对准
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "竹篮打水一场空。",		--夹夹绞盘没捞到东西

	ANNOUNCE_BOAT_LEAK = "泉声噪如玉……不太妙……",		--船上出现了新的漏洞
	ANNOUNCE_BOAT_SINK = "沉船斩馘海为膻，潭底潜蛟喷血涎……。",		--船正在裂开，马上要沉了
-----一些单独的检查台词 ------------------------------------------------------------------------------------------------
	-- 检查相同角色
	-- DESCRIBE_SAMECHARACTER = "",
	ANNOUNCE_LUNARHAIL_BIRD_SOUNDS = "What is that racket?",
	ANNOUNCE_LUNARHAIL_BIRD_CORPSES = "That's not a good sign.", -- 月雹期间鸟类坠落死亡
	ANNOUNCE_FLOAT_SWIM_TIRED = "I can't!",
	ANOUNCE_MUTATED_BIRD_ATTACK = "Blasted birds!",
	-- 猴子诅咒
	ANNOUNCE_CANT_ESCAPE_CURSE = "没法甩掉他。",	--诅咒饰品无法直接扔掉
	ANNOUNCE_MONKEY_CURSE_1 = "感觉不太好……",	--获得诅咒饰品，脚变成猴子脚
	ANNOUNCE_MONKEY_CURSE_CHANGE = "诶呦，我的头发。",	--诅咒饰品到达堆叠上限后变成芜猴
	ANNOUNCE_MONKEY_CURSE_CHANGEBACK = "我不想再经历一次了。",	--诅咒饰品全部去除，变回原样
	-- 角色专属
	ANNOUNCE_FOODMEMORY = "only_used_by_warly",-- 沃利(大厨)触发食物记忆
	-- 温蒂专属
	ANNOUNCE_SISTURN_FULL_EVIL = "only_used_by_wendy", -- 温蒂的灵柩充满邪恶能量时触发
	ANNOUNCE_SISTURN_FULL_BLOSSOM = "only_used_by_wendy", -- 温蒂的灵柩充满生命能量时触发
	ANNOUNCE_GHOST_QUEST = "only_used_by_wendy",-- 温蒂为小惊吓找到玩具
	-- 温蒂召唤阿比盖尔
	ANNOUNCE_ABIGAIL_SUMMON =
	{
		LEVEL1 = "only_used_by_wendy",
		LEVEL2 = "only_used_by_wendy",
		LEVEL3 = "only_used_by_wendy",
	},
	-- 阿比盖尔升级
	ANNOUNCE_GHOSTLYBOND_LEVELUP =
	{
		LEVEL2 = "only_used_by_wendy",
		LEVEL3 = "only_used_by_wendy",
	},
	-- 女武神
	ANNOUNCE_NOINSPIRATION = "only_used_by_wathgrithr", -- 瓦格弗德尝试创作但灵感不足时触发
	ANNOUNCE_NOTSKILLEDENOUGH = "only_used_by_wathgrithr", -- 瓦格弗德尝试使用未解锁的技能时触发
	ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr", -- 瓦格弗德激活嘲讽类战歌时触发
	ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr", -- 瓦格弗德激活恐慌类战歌时触发
	ANNOUNCE_BATTLESONG_INSTANT_REVIVE_BUFF = "only_used_by_wathgrithr", -- 瓦格弗德激活复活类战歌时触发
	-- 旺达
	ANNOUNCE_WANDA_YOUNGTONORMAL = "only_used_by_wanda", -- 旺达使用怀表从年轻形态恢复正常时触发
	ANNOUNCE_WANDA_NORMALTOOLD = "only_used_by_wanda", -- 旺达使用怀表从正常形态变年老时触发
	ANNOUNCE_WANDA_OLDTONORMAL = "only_used_by_wanda", -- 旺达使用怀表从年老形态恢复正常时触发
	ANNOUNCE_WANDA_NORMALTOYOUNG = "only_used_by_wanda", -- 旺达使用怀表从正常形态变年轻时触发
	-- 旺达传送相关
	ANNOUNCE_POCKETWATCH_PORTAL = "云栾波涛，千里枯路。",		--从旺达的传送门里出来
	ANNOUNCE_POCKETWATCH_MARK = "就在这里埋下梦境的锚点吧。", 				   -- 使用怀表标记位置时触发
	ANNOUNCE_POCKETWATCH_RECALL = "大梦谁先觉？平生我自知。", 			-- 使用怀表召回至标记位置时触发
	ANNOUNCE_POCKETWATCH_OPEN_PORTAL = "时间不多，你我要同做一场大梦。",		-- 使用怀表开启传送门时触发
	ANNOUNCE_POCKETWATCH_OPEN_PORTAL_DIFFERENTSHARD = "来路三千，云烟万重。",  -- 尝试开启跨服务器传送门时触发
	-- WX-78过载状态
	ANNOUNCE_CHARGE = "only_used_by_wx78",	  -- 被闪电击中进入过载状态
	ANNOUNCE_DISCHARGE = "only_used_by_wx78", -- 过载状态结束
	--  薇落娜激活黑暗痕迹时的台词
	ANNOUNCE_ROSEGLASSES = 
	{
		"only_used_by_winona",
		"only_used_by_winona",
		"only_used_by_winona",
	},

	ANNOUNCE_CHARLIE_MISSED = "哼，再来！",-- 薇落娜抵挡查理攻击
	-- 麦斯威尔与暗影强化装备
	-- 麦斯威尔与暗影强化装备
	ANNOUNCE_SHADOWLEVEL_ITEM = "它寄宿着暗影的力量……!",	      -- 检查可提供暗影魔法的物品时添加在语句后的描述
	ANNOUNCE_EQUIP_SHADOWLEVEL_T1 = "有趣,我的暗影仆从们变强了。", -- 穿戴可提升1级暗影魔法强度的装备
	ANNOUNCE_EQUIP_SHADOWLEVEL_T2 = "暗影的力量在我身上滋长……",   -- 穿戴可提升2级暗影魔法强度的装备
	ANNOUNCE_EQUIP_SHADOWLEVEL_T3 = "暗影已经完全向我称臣！",	   -- 穿戴可提升3级暗影魔法强度的装备
	ANNOUNCE_EQUIP_SHADOWLEVEL_T4 = "恭迎你们新的暗影之王吧！",    -- 穿戴可提升4级暗影魔法强度的装备
	-- 沃尔夫冈(大力士)训练时闲聊
	ANNOUNCE_COACH = 
	{
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
	},
	-- 沃尔夫冈不同形态变化
	ANNOUNCE_NORMALTOMIGHTY = "only_used_by_wolfang",		--吃饱到猛男形态（沃尔夫冈专用）
	ANNOUNCE_NORMALTOWIMPY = "only_used_by_wolfang",		--饿到弱鸡形态（沃尔夫冈专用）
	ANNOUNCE_WIMPYTONORMAL = "only_used_by_wolfang",		--吃到一般形态（沃尔夫冈专用）
	ANNOUNCE_MIGHTYTONORMAL = "only_used_by_wolfang",		--饿到一般形态（沃尔夫冈专用）
	-- 沃尔夫冈不同形态退出健身房
	ANNOUNCE_EXITGYM = {
		MIGHTY = "only_used_by_wolfang",	--猛男形态退出健身房
		NORMAL = "only_used_by_wolfang",	--一般形态退出健身房
		WIMPY = "only_used_by_wolfang",	--弱鸡形态退出健身房
	},
	-- 沃尔夫冈不同形态锻炼
	ANNOUNCE_WOLFGANG_WIMPY_COACHING = "only_used_by_wolfgang", -- 小力士锻炼
    ANNOUNCE_WOLFGANG_MIGHTY_COACHING = "only_used_by_wolfgang",-- 中力士锻炼
    ANNOUNCE_WOLFGANG_BEGIN_COACHING = "only_used_by_wolfgang", -- 大力士锻炼
    ANNOUNCE_WOLFGANG_END_COACHING = "only_used_by_wolfgang",   -- 疑似停止锻炼
	-- 沃尔夫刚暂时未知
	ANNOUNCE_WOLFGANG_NOTEAM = 
	{
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
		"only_used_by_wolfgang",
	},
	-- 温蒂保姆模式？
	ANNOUNCE_WENDY_BABYSITTER_SET = "only_used_by_wendy",
	ANNOUNCE_WENDY_BABYSITTER_STOP = "only_used_by_wendy",
	-- 温蒂专属-召唤阿比盖尔
	ANNOUNCE_NO_ABIGAIL_FLOWER = "only_used_by_wendy", -- 温蒂尝试召唤阿比盖尔但未携带阿比盖尔之花
	-- 远古档案馆相关
	ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "神奇的知识，或许年可以根据它复刻出自己想要的结果？",		--学到知识饮水机的知识
	ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "我已经知道了。",		--学习已经学过的知识饮水机的知识
	ANNOUNCE_ARCHIVE_NO_POWER = "它需要能源才能运行。",		--档案馆能源未启动时尝试使用知识饮水机
	-- 圣殿相关
	ANNOUNCE_VAULT_TELEPORTER_DOES_NOTHING = "得到达另一端才能修好它。", -- 使用圣殿路标但没有反应
	ANNOUNCE_LIGHTSOUT_SHADOWHAND = "也许它能帮到我？", -- 圣殿内点灯解密时与暗影之手交互
------ 活动内容
	-- 冬季盛宴：
	ANNOUNCE_EATING_NOT_FEASTING = "我应该跟其他人分享的。",		--（未应用）
	ANNOUNCE_WINTERS_FEAST_BUFF = "满满的节日精神！",		--享用冬季盛宴食物后获得buff
	ANNOUNCE_IS_FEASTING = "冬季盛宴快乐！",		--开始享用冬季盛宴食物
	ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "若白驹过隙，忽然而已……",		--冬季盛宴buff结束
	-- 堆雪人
	ANNOUNCE_SNOWBALL_TOO_BIG = "白雪皑皑覆大地，堆雪人欢笑语频。", -- 雪人堆到体积上限。
	ANNOUNCE_SNOWBALL_NO_SNOW = "这里没有足够的雪。",   -- 当前区域没有雪
	-- 有关进食食物的进食台词
	EAT_FOOD =
	{
		TALLBIRDEGG_CRACKED = "它已经长出喙了…",		--吃孵化的高脚鸟蛋
		WINTERSFEASTFUEL = "节日的味道。",		--吃节日欢愉
	},
	-- 万圣节：
	ANNOUNCE_SPOOKED = "呼，让我先喝一杯，压压惊。",		--被万圣节蝙蝠吓到
	ANNOUNCE_BRAVERY_POTION = "勇气是人类的赞歌。",		--喝下勇气药剂
	ANNOUNCE_MOONPOTION_FAILED = "月亮的精华对它不起作用。",		--月亮精华液使用失败
	ANNOUNCE_NOPUMPKINCARVINGONFIRE = "戒骄戒躁，莫动肝火。", -- 玩家尝试在燃烧的南瓜上雕刻
	-- 龙蝇年赛龙舟
	ANNOUNCE_YOTD_NOBOATS = "这里可看不清开始比赛的信号。",	--距离起点太远，无法开始龙舟比赛
	ANNOUNCE_YOTD_NOCHECKPOINTS = "我该先立几个检查点。",	--无检查点，无法开始龙舟比赛
	ANNOUNCE_YOTD_NOTENOUGHBOATS = "空间太小，容纳不了其余选手了。",	--周围太拥挤无法生成查理的选手，无法开始龙舟比赛
	-- 浣猫年捉迷藏活动
	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "数罢，戏幕启。",	--开始捉迷藏
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN = "童心未泯，让我也游玩一番。",		--加入正在进行的捉迷藏
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND = 
	{
		"找到你了！",		--找到小浣猫
		"你在这里。",		--找到小浣猫
		"在这里哦。",		--找到小浣猫
		"看到你了。",		--找到小浣猫
	},
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_ONE_MORE = "所以最后一个藏在哪里呢？",	--还剩最后一只
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE = "我找到最后一个了！",	--找到最后一只
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE_TEAM = "{name}找到了最后一个！",		--队友找到最后一只
	ANNOUNCE_KITCOON_HIDANDSEEK_TIME_ALMOST_UP = "那些小家伙们估计不耐烦了……",		--捉迷藏时间不够了
	ANNOUNCE_KITCOON_HIDANDSEEK_LOSEGAME = "看来它们不想玩了……",	--捉迷藏失败
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR = "它们大概率不会躲在这么远的地方，对吧？",	--远离小浣猫躲藏区域
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR_RETURN = "小浣猫们应该就在附近。",	--返回小浣猫躲藏区域
	ANNOUNCE_KITCOON_FOUND_IN_THE_WILD = "我就说刚刚看到了那边有什么东西在藏着！",	--找到野生小浣猫

	ANNOUNCE_TICOON_START_TRACKING	= "他捕捉到了气味！",		--大虎开始追踪
	ANNOUNCE_TICOON_NOTHING_TO_TRACK = "看来他什么都没找到。",		--大虎在此区域未发现小浣猫
	ANNOUNCE_TICOON_WAITING_FOR_LEADER = "我应该跟着他！",	--大虎在等待玩家
	ANNOUNCE_TICOON_GET_LEADER_ATTENTION = "他很想让我跟着。",		--大虎在呼叫玩家
	ANNOUNCE_TICOON_NEAR_KITCOON = "他一定是发现了什么！",		--大虎发现了小浣猫
	ANNOUNCE_TICOON_LOST_KITCOON = "看来别人找到了他要找的东西。",	--有人先一步发现了小浣猫
	ANNOUNCE_TICOON_ABANDONED = "我会自己找到那些小家伙的。",	--遗弃大虎
	ANNOUNCE_TICOON_DEAD = "可怜的家伙……他原本想把我带到哪里呢？",		--大虎死亡
	-- 皮弗娄牛年活动相关
	ANNOUNCE_CALL_BEEF = "到这里来。",		--把牛叫过来栓到美妆台上
	ANNOUNCE_CANTBUILDHERE_YOTB_POST = "离裁判席太远了。",		--皮弗娄牛展示台建造位置里裁判席太远
	ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "我有很多想法。",		--学习了新的皮弗娄牛礼服样式
	-- 熔炉相关
	ANNOUNCE_REVIVING_CORPSE = "让我帮帮你。",		--（未应用）（熔炉）
	ANNOUNCE_REVIVED_OTHER_CORPSE = "焕然一新！",		--（未应用）（熔炉）
	ANNOUNCE_REVIVED_FROM_CORPSE = "好多了，谢谢啦。",		--（未应用）（熔炉）
	-- 胡萝卜鼠之年
	ANNOUNCE_CARRAT_START_RACE = "去吧，胡萝卜鼠！",		--胡萝卜鼠赛跑开始
	-- 胡萝卜鼠朝赛跑终点反方向移动时触发
	ANNOUNCE_CARRAT_ERROR_WRONG_WAY = {
		"方向错了！",
		"它真的认识路吗…",
	},
	ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "现在可不是入梦的时候！",		--胡萝卜鼠耐力不够，比赛昏昏欲睡
	ANNOUNCE_CARRAT_ERROR_WALKING = "应该让大哥帮我训练训练的。",		--胡萝卜鼠跑得太慢
	ANNOUNCE_CARRAT_ERROR_STUNNED = "一步慢，步步慢。",		--胡萝卜鼠反应力不够，起跑慢
	ANNOUNCE_WEAK_RAT = "它看起来状态不好。",		--胡萝卜鼠新鲜度太低，无法进行训练和比赛
	-- 发条骑士之年
	ANNOUNCE_YOTH_ONCOOLDOWN = "毋用疲兵。", -- 冷却期间尝试召唤四骑士
------ 检查 	-------------------------------------------------------------------------------------------------------------------------------------------
	DESCRIBE =
	{
		-- 检查玩家，模版
		PLAYER =
		{
			GENERIC = "还好吗，%s ？",		-- 物品名:"默认角色"->默认
			ATTACKER = "%s 兵无常势，水无常形···",		-- 物品名:"默认角色"->攻击队友
			MURDERER = "又一场腥风血雨。",		-- 物品名:"默认角色"->杀死队友
			REVIVER = "做了场噩梦没关系，欢迎回来，%s。",		-- 物品名:"默认角色"->复活队友
			GHOST = "%s ，我寄愁心与明月，随君直到夜郎西。",		-- 物品名:"默认角色"->死了
			FIRESTARTER = "%s，毋要引火上身。",		-- 物品名:"默认角色"->烧家
		},
-----------检查其他玩家角色&角色专属物品-----------------------------------------------------------------------------------
		-- 威尔逊
		WILSON =
		{
			GENERIC = "星星和原子！你是我的分身吗？",		-- 物品名:"威尔逊"->默认
			ATTACKER = "是的。我总是看起来很吓人吗？",		-- 物品名:"威尔逊"->攻击队友
			MURDERER = "你的存在触犯了科学规律，%s！",		-- 物品名:"威尔逊"->杀死队友
			REVIVER = "%s很专业地将我们的理论付诸实现。",		-- 物品名:"威尔逊"->复活队友
			GHOST = "最好弄个复活设备。不能让另一个科学人漂着。",		-- 物品名:"威尔逊"->死了
			FIRESTARTER = "烧掉这个并不科学，%s。",		-- 物品名:"威尔逊"->烧家
		},
		-- 沃尔夫冈
		WOLFGANG =
		{
			GENERIC = "很高兴见到你，%s！",		-- 物品名:"沃尔夫冈"->默认
			ATTACKER = "不要和强者挑起战斗...",		-- 物品名:"沃尔夫冈"->攻击队友
			MURDERER = "谋杀犯！我能抓到你！",		-- 物品名:"沃尔夫冈"->杀死队友
			REVIVER = "%s只是一只巨型泰迪熊。",		-- 物品名:"沃尔夫冈"->复活队友
			GHOST = "我跟你说过不要硬拉那个大石头了。数值都不对。",		-- 物品名:"沃尔夫冈"->死了
			FIRESTARTER = "你是没法打倒火的，%s！",		-- 物品名:"沃尔夫冈"->烧家
		},
		WOLFGANG_WHISTLE = "哨令。",	-- 物品名:"训练哨" 制造描述:"释放你心底潜在的教练！"
		-- 健身房
		MIGHTY_GYM = 
		{
			GENERIC = "只得形，毋得神。",	-- 物品名:"强大健身房"->默认
			BURNT = "结束了。",		-- 物品名:"强大健身房"->烧焦了
		},
		POTATOSACK = "一袋土豆,看起来有人喜欢用它当健身工具。",		-- 物品名:"土豆袋"
		DUMBBELL = "看起来有效果。",		-- 物品名:"哑铃"
		DUMBBELL_GOLDEN = "精诚所至，金石为开。",		-- 物品名:"黄金哑铃"
		DUMBBELL_MARBLE = "沉重的大理石哑铃",	-- 物品名:"大理石哑铃"
		DUMBBELL_GEM = "有点昂贵。",		-- 物品名:"宝石哑铃"
		DUMBBELL_HEAT = "用来热身还不错。",	-- 物品名:"热铃" 制造描述:"进行终极热身。"
		DUMBBELL_REDGEM = "快速燃烧自己。",	-- 物品名:"火铃" 制造描述:"感受燃烧！"
		DUMBBELL_BLUEGEM = "太“冷”酷了。",	-- 物品名:"冰铃" 制造描述:"冷落会影响到锻炼。"
		--- 麦斯威尔
		WAXWELL =
		{
			GENERIC = "日安，%s！",		-- 物品名:"麦斯威尔"->默认
			ATTACKER = "你似乎从“说话干净利落”变成“粘舌”。",		-- 物品名:"麦斯威尔"->攻击队友
			MURDERER = "我要教教你逻辑和推理...这是我的强项！",		-- 物品名:"麦斯威尔"->杀死队友
			REVIVER = "%s他把能力用在正义的事业。",		-- 物品名:"麦斯威尔"->复活队友
			GHOST = "不要那样看我，%s！我在努力！",		-- 物品名:"麦斯威尔"->死了
			FIRESTARTER = "%s只求火烤。",		-- 物品名:"麦斯威尔"->烧家
		},
		-- 暗影秘典
		WAXWELLJOURNAL =
		{
			GENERIC = "使用暗影的力量迟早会被反噬。",		-- 物品名:"暗影秘典"->默认 制造描述:"这将让你大吃一惊。"
			NEEDSFUEL = "only_used_by_waxwell",	-- 物品名:"暗影秘典"->噩梦燃料不足 制造描述:"这将让你大吃一惊。"（老麦专用）
		},
		MAGICIAN_CHEST = "多维度运输。",	-- 物品名:"魔术师箱子" 制造描述:"测试所有最新可装备外观的模特。"
		TOPHAT_MAGICIAN = "增加了暗影魔法。",	-- 物品名:"魔术师高礼帽" 制造描述:"测试所有最新可装备外观的模特。"
		-- 机器人
		WX78 =
		{
			GENERIC = "日安，%s！",		-- 物品名:"WX-78"->默认
			ATTACKER = "%s，我想我们得调整你的首要指令...",		-- 物品名:"WX-78"->攻击队友
			MURDERER = "%s！你已经违反了第一律法！",		-- 物品名:"WX-78"->杀死队友
			REVIVER = "我猜是%s让感同身受组件启动并运行。",		-- 物品名:"WX-78"->复活队友
			GHOST = "我一直认为%s该长点心。现在，我很确定！",		-- 物品名:"WX-78"->死了
			FIRESTARTER = "%s！你看起来快融化了。发生什么事？",		-- 物品名:"WX-78"->烧家
		},
		WX78_MODULEREMOVER = "奇特的电路板。",	-- 物品名:"电路提取器"

		WX78MODULE_MAXHEALTH = "奇特的电路板。",	-- 物品名:"强化电路"
		WX78MODULE_MAXSANITY1 = "奇特的电路板。",	-- 物品名:"处理器电路"
		WX78MODULE_MAXSANITY = "奇特的电路板。",	-- 物品名:"超级处理器电路"
		WX78MODULE_MOVESPEED = "奇特的电路板。",	-- 物品名:"加速电路"
		WX78MODULE_MOVESPEED2 = "奇特的电路板。",	-- 物品名:"超级加速电路"
		WX78MODULE_HEAT = "奇特的电路板。",	-- 物品名:"热能电路"
		WX78MODULE_NIGHTVISION = "奇特的电路板。",	-- 物品名:"光电电路"
		WX78MODULE_COLD = "奇特的电路板。",	-- 物品名:"制冷电路"
		WX78MODULE_TASER = "奇特的电路板。",	-- 物品名:"电气化电路"
		WX78MODULE_LIGHT = "奇特的电路板。",	-- 物品名:"照明电路"
		WX78MODULE_MAXHUNGER1 = "奇特的电路板。",	-- 物品名:"胃增益电路"
		WX78MODULE_MAXHUNGER = "奇特的电路板。",	-- 物品名:"超级胃增益电路"
		WX78MODULE_MUSIC = "奇特的电路板。",	-- 物品名:"合唱盒电路"
		WX78MODULE_BEE = "奇特的电路板。",	-- 物品名:"豆豆电路"
		WX78MODULE_MAXHEALTH2 = "奇特的电路板。",	-- 物品名:"超级强化电路"
		-- 生物扫描分析仪
		WX78_SCANNER = 
		{
			GENERIC = "WX-可以用它扫描生物。",	-- 物品名:"生物扫描分析仪"->默认
			HUNTING = "抓住那份数据！",	-- 物品名:"生物扫描分析仪"->追踪中
			SCANNING = "似乎有新的发现。",	-- 物品名:"生物扫描分析仪"->扫描中
		},
		WX78_SCANNER_ITEM = "WX-可以用它扫描生物。",	-- 物品名:"生物扫描分析仪"->物品状态
		WX78_SCANNER_SUCCEEDED = "完成了。",	-- 物品名:"生物扫描分析仪"->扫描完成
		SCANDATA = "有趣的数据。",	-- 物品名:"生物数据"
		-- 薇洛，火女
		WILLOW =
		{
			GENERIC = "日安，%s！",		-- 物品名:"薇洛"->默认
			ATTACKER = "%s紧紧抓住那个打火机...",		-- 物品名:"薇洛"->攻击队友
			MURDERER = "谋杀犯！纵火犯！",		-- 物品名:"薇洛"->杀死队友
			REVIVER = "%s，鬼魂的朋友。",		-- 物品名:"薇洛"->复活队友
			GHOST = "%s，我敢肯定你渴望有一颗心。",		-- 物品名:"薇洛"->死了
			FIRESTARTER = "再来？",		-- 物品名:"薇洛"->烧家
		},
		LIGHTER  = "掌控火焰的力量。",		-- 物品名:"薇洛的打火机" 制造描述:"火焰在雨中彻夜燃烧。"
		EMBERLIGHT = "谨慎使用你的法术，火焰远没有你想象的那样好掌控。",	--物品名:"火球术"
		-- 伯尼熊
		BERNIE_INACTIVE =
		{
			BROKEN = "余烬终熄。",		-- 物品名:"伯尼"->被击败 制造描述:"这个疯狂的世界总有你熟悉的人。"
			GENERIC = "面目全非。",		-- 物品名:"伯尼"->默认 制造描述:"这个疯狂的世界总有你熟悉的人。"
		},
		BERNIE_ACTIVE = "一只类似器伥的泰迪熊。",		-- 物品名:"伯尼"->就绪
		BERNIE_BIG = "不要惹怒薇洛。",		-- 物品名:"伯尼！"->变大形态
		WILLOW_EMBER = "only_used_by_willow",	--物品名:"以太余烬"
		-- 温蒂
		WENDY =
		{
			GENERIC = "你好，%s！",		-- 物品名:"温蒂"->默认
			ATTACKER = "%s没有尖锐的东西，有吗？",		-- 物品名:"温蒂"->攻击队友
			MURDERER = "谋杀犯！",		-- 物品名:"温蒂"->杀死队友
			REVIVER = "%s视鬼魂为家人。",		-- 物品名:"温蒂"->复活队友
			GHOST = "我看到两个！我最好给%s制造一颗心。",		-- 物品名:"温蒂"->死了
			FIRESTARTER = "我知道是你点的那些火焰，%s。",		-- 物品名:"温蒂"->烧家
		},
		-- 阿比盖尔之花
		ABIGAIL_FLOWER =
		{
			GENERIC ="寄宿着双生姊妹已逝之人的花。",		-- 物品名:"阿比盖尔之花"->默认 制造描述:"一个神奇的纪念品。"
			LEVEL1 = "看起来有点害羞。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			LEVEL2 = "还好吗？",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			LEVEL3 = "来喝一杯吗，阿比盖尔？",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			-- 阿比盖尔死亡等待复活状态
			LONG = "唉，可惜了。",		-- 物品名:"阿比盖尔之花"->还需要很久 制造描述:"一个神奇的纪念品。"
			MEDIUM = "希望温蒂不会太伤心。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			SOON = "这朵花的情况不太对",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			HAUNTED_POCKET = "我应该放下它。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
			HAUNTED_GROUND = "不知道它到底做了些什么。",		-- 物品名:"阿比盖尔之花" 制造描述:"一个神奇的纪念品。"
		},
		-- 阿比盖尔
		ABIGAIL =
		{
			LEVEL1 =
			{
				"可爱的小家伙。",		-- 物品名:阿比盖尔->一阶段
				"你的姐姐很想你。",		-- 物品名:阿比盖尔->一阶段
			},
			LEVEL2 =
			{
				"死亡也无法分开你们。",		-- 物品名:阿比盖尔->二阶段
				"你的姐姐很在乎你。",		-- 物品名:阿比盖尔->二阶段
			},
			LEVEL3 =
			{
				"祝你们好运。",		-- 物品名:阿比盖尔->三阶段
				"至少现在你和你的姐姐不会分开了。",		-- 物品名:阿比盖尔->三阶段
			},
		},
		GHOSTLYELIXIR_SLOWREGEN = "此药非为生，抚却梦中痕。",		-- 物品名:"亡者补药" 制造描述:"时间会抚平所有伤口。"
		GHOSTLYELIXIR_FASTREGEN = "凝魂溯光阴，塑魄愈重渊。",		-- 物品名:"灵魂万灵药" 制造描述:"治疗重伤的强力药剂。"
		GHOSTLYELIXIR_SHIELD = "长夜终尽，旧忆为烬。",		-- 物品名:"不屈药剂" 制造描述:"保护你的姐妹不受伤害。"
		GHOSTLYELIXIR_ATTACK = "借眸幽冥，洞彻永夜",		-- 物品名:"夜影万金油" 制造描述:"召唤黑暗的力量。"
		GHOSTLYELIXIR_SPEED = "涤浊焕新魄，身随意驰骋。",		-- 物品名:"强健精油" 制造描述:"给你的灵魂来一剂强心针。"
		GHOSTLYELIXIR_RETALIATION = "铁棘镜罡，触之即殛。",		-- 物品名:"蒸馏复仇" 制造描述:"对敌人以牙还牙。"
		--  墓地花瓶
        GRAVEURN =
        {
            GENERIC = "空空荡荡，一如其思。", --  无花
            HAS_SPIRIT = "装点哀伤。",       --  有花
        },
		-- 姐妹骨灰罐
		SISTURN =
		{
			GENERIC = "风过无香驻，长夜待芳辰。",		-- 物品名:"姐妹骨灰罐"->默认 制造描述:"让你疲倦的灵魂休息的地方。"
			SOME_FLOWERS = "一瓣衔芳驻，轻语慰长眠。",		-- 物品名:"姐妹骨灰罐"->有一些花  制造描述:"让你疲倦的灵魂休息的地方。"
			LOTS_OF_FLOWERS = "千瓣拢香凝旧梦，不复长夜待归人。",		-- 物品名:"姐妹骨灰罐"->装满花 制造描述:"让你疲倦的灵魂休息的地方。"
		},
		-- 伍迪
		WOODIE =
		{
			GENERIC = "你好，%s！",		-- 物品名:"伍迪"->默认
			ATTACKER = "%s最近有点活力...",		-- 物品名:"伍迪"->攻击队友
			MURDERER = "凶手！来把斧子，我们砍起来！",		-- 物品名:"伍迪"->杀死队友
			REVIVER = "%s救下了大家的培根。",		-- 物品名:"伍迪"->复活队友
			GHOST = "%s，“宇宙”包括虚无吗？",		-- 物品名:"伍迪"->死了
			BEAVER = "%s在疯狂的砍树，根本停不下来！",		-- 物品名:"伍迪"->海狸形态
			BEAVERGHOST = "%s，如果我不复活你，你会生气吗？",		-- 物品名:"伍迪"->海狸形态死了
			MOOSE = "天老爷啊，这是一头鹿！",		-- 物品名:"伍迪"->麋鹿形态
			MOOSEGHOST = "那一定很不舒服吧。",		-- 物品名:"伍迪"->麋鹿形态死了
			GOOSE = "瞧瞧这玩意！",		-- 物品名:"伍迪"->鹅形态
			GOOSEGHOST = "以后长点心，你这头蠢鹅！",		-- 物品名:"伍迪"->鹅形态死了
			FIRESTARTER = "%s，别把自己烧了。",		-- 物品名:"伍迪"->烧家
		},
		LUCY = "一把器伥。",		-- 物品名:"露西斧"
		WEREITEM_BEAVER = "他需要直面自己的诅咒。",		-- 物品名:"俗气海狸像" 制造描述:"唤醒海狸人的诅咒"
		WEREITEM_GOOSE = "他需要直面自己的诅咒。",		-- 物品名:"俗气鹅像" 制造描述:"唤醒鹅人的诅咒"
		WEREITEM_MOOSE = "他需要直面自己的诅咒。",		-- 物品名:"俗气鹿像" 制造描述:"唤醒鹿人的诅咒"
		LEIF_IDOL = "烧掉它会让树木极其愤怒。",	-- 物品名:"树精守卫雕像" 制造描述:"召唤树木的力量。"
		WOODCARVEDHAT = "坚固的伐木工帽。",	-- 物品名:"硬木帽" 制造描述:"你的脑袋会被保护得很好（敲敲木头防止乌鸦嘴）。"
		WALKING_STICK = "这是一根非常好的棍子。",	-- 物品名:"木手杖" 制造描述:"轻松穿越您最喜欢的自然小径。"
		-- 薇克巴顿，老奶奶
		WICKERBOTTOM =
		{
			GENERIC = "日安，%s！",		-- 物品名:"薇克巴顿"->默认
			ATTACKER = "我感觉%s准备拿书丢我。",		-- 物品名:"薇克巴顿"->攻击队友
			MURDERER = "同行评审来了！",		-- 物品名:"薇克巴顿"->杀死队友
			REVIVER = "我对%s的实践原理深怀敬意。",		-- 物品名:"薇克巴顿"->复活队友
			GHOST = "这似乎不太科学，不是吗，%s？",		-- 物品名:"薇克巴顿"->死了
			FIRESTARTER = "我相信你很有理由才点火。",		-- 物品名:"薇克巴顿"->烧家
		},
		-- 书架
		BOOKSTATION =
		{
			GENERIC = "或许我的诗集也能放进去？",	-- 物品名:"书架"->默认 制造描述:"所有图书均须遵循杜威十进制分类法整理。"
			BURNT = "可惜了里面的书了",	-- 物品名:"书架"->烧毁 制造描述:"所有图书均须遵循杜威十进制分类法整理。"
		},
		-- 书籍
		BOOK_BIRDS = "凤兮凤兮 何德之衰。",		-- 物品名:"世界鸟类大全" 制造描述:"涵盖1000个物种：习性、栖息地及叫声。"
		BOOK_TENTACLES = "看着就恶心。",		-- 物品名:"触手的召唤" 制造描述:"让我们来了解一下地下的朋友们！"
		BOOK_GARDENING = "附近没有作物，或许我应该去黍的农田试试？",		-- 物品名:"应用园艺学" 制造描述:"讲述培育和照料植物的相关知识。"
		BOOK_SILVICULTURE = "欲富先栽树。",		-- 物品名:"应用造林学" 制造描述:"分支管理的指引。"
		BOOK_HORTICULTURE = "附近没有作物，或许我应该去黍的农田试试？",		-- 物品名:"应用园艺学，简编" 制造描述:"讲述培育和照料植物的相关知识。"
		BOOK_SLEEP = "至少比黍的唠叨好点。",		-- 物品名:"睡前故事" 制造描述:"送你入梦的睡前故事。"
		BOOK_BRIMSTONE = "火焰，荡涤罪恶。",		-- 物品名:"末日将至！" 制造描述:"世界将在火焰和灾难中终结！"
		BOOK_FISH = "授人以鳞莫如授人以渔！",	-- 物品名:"垂钓者生存指南" 制造描述:"让捕鱼变得简单！"
		BOOK_FIRE = "希望附近没有火灾。",	-- 物品名:"意念控火术详解" 制造描述:"使用这些简单的技巧来化解任何火爆的场面。"
		BOOK_WEB = "我即我，宁做我，无惧外物。",	-- 物品名:"克服蛛形纲恐惧症" 制造描述:"要在对方的网络里行走过一里路才能算真正了解一个人。"
		BOOK_TEMPERATURE = "不温不火。",	-- 物品名:"控温学" 制造描述:"通过这些简单的步骤完全控制你的个人气候。"
		BOOK_LIGHT = "灵光乍现。",	-- 物品名:"永恒之光" 制造描述:"阅读后能启迪出智慧的光芒。"
		BOOK_RAIN = "呼风唤雨。",	-- 物品名:"实用求雨仪式" 制造描述:"留着防备雨天，你来决定哪天是雨天。"
		BOOK_MOON = "明月圆缺，听吾号令。",	-- 物品名:"月之魔典" 制造描述:"召唤月亮的力量。"
		BOOK_BEES = "会嗡嗡响的书，但是里面没有另一方世界。",	-- 物品名:"养蜂笔记" 制造描述:"学习养蜂的基本知识。"
		BOOK_HORTICULTURE_UPGRADED = "书中和我的梦一样，寒来暑往，秋收冬藏。",	-- 物品名:"园艺学扩展版" 制造描述:"专家分析如何进行高级农作物护理。"
		BOOK_RESEARCH_STATION = "算尽天下无遗策。",	-- 物品名:"万物百科" 制造描述:"万事万物从A到Z的完整指南。"
		BOOK_LIGHT_UPGRADED = "光芒！灿若黄金！",	-- 物品名:"永恒之光之复兴" 制造描述:"全本比之前的简本散发出更闪耀的光芒。"
		FIREPEN = "趁热打笔！",	-- 物品名:"火焰笔" 制造描述:"小小的笔身中潜藏着暴躁的火焰。"
		-- 维斯
		WES =
		{
			GENERIC = "你好，%s！",		-- 物品名:"韦斯"->默认
			ATTACKER = "%s死寂般沉默...",		-- 物品名:"韦斯"->攻击队友
			MURDERER = "用哑剧表达这个！",		-- 物品名:"韦斯"->杀死队友
			REVIVER = "%s突破固有的思维模式。",		-- 物品名:"韦斯"->复活队友
			GHOST = "怎样用哑剧动作表示“我要弄个复活装备”？",		-- 物品名:"韦斯"->死了
			FIRESTARTER = "等等，不要跟我说。火是你点的。",		-- 物品名:"韦斯"->烧家
		},
		BALLOONS_EMPTY = "气球总是能给人们带来欢愉。",		-- 物品名:"一堆气球" 制造描述:"要是有更简单的方法该多好。"
		BALLOON = "它漂在空中。",		-- 物品名:"气球" 制造描述:"谁不喜欢气球呢？"
		BALLOONPARTY = "气球派对。",		-- 物品名:"派对气球" 制造描述:"散播一点欢笑。"
		 -- 迅捷手杖
		BALLOONSPEED =
		{
			DEFLATED = "所有气球都一样。",		-- 物品名:"迅捷气球"->耐久较低 制造描述:"让你的脚步变得轻盈。"
			GENERIC = "好风凭借力，送我步青云。",		-- 物品名:"迅捷气球"->默认 制造描述:"让你的脚步变得轻盈。"
		},
		BALLOONVEST = "在海上穿上它是个好主意。",		-- 物品名:"充气背心" 制造描述:"划船时带上这些艳丽的气球。"
		BALLOONHAT = "欸哟，静电让我的尾巴炸毛了。",		-- 物品名:"气球帽" 制造描述:"开启对话的出色工具！"
		-- 韦伯，蜘蛛男孩
		WEBBER =
		{
			GENERIC = "日安，%s！",		-- 物品名:"韦伯"->默认
			ATTACKER = "我会卷起一张纸莎草报纸，以防万一。",		-- 物品名:"韦伯"->攻击队友
			MURDERER = "杀人凶手！我要灭了你，%s！",		-- 物品名:"韦伯"->杀死队友
			REVIVER = "%s和其他人打成一片。",		-- 物品名:"韦伯"->复活队友
			GHOST = "%s真的很想让我给它一颗心。",		-- 物品名:"韦伯"->死了
			FIRESTARTER = "我们得开个防火安全群组会议。",		-- 物品名:"韦伯"->烧家
		},
		SPIDER_WHISTLE = "只有韦伯能用。",		-- 物品名:"韦伯口哨" 制造描述:"呼叫可怕的爬行动物朋友吧。"
		SPIDERDEN_BEDAZZLER = "看起来某人的手艺提高了不少啊。",		-- 物品名:"蛛巢装饰套装" 制造描述:"一个好的家能培育出好的性格。"
		SPIDER_REPELLENT = "用于震慑和管理蜘蛛。",		-- 物品名:"驱赶盒子" 制造描述:"让你的朋友知道你需要一些空间。"
		SPIDER_HEALER_ITEM = "专为蜘蛛设计的。",		-- 物品名:"治疗黏团" 制造描述:"恶心，黏糊糊的，但对你有好处！"
		MUTATOR_WARRIOR = "怪物曲奇饼，让韦伯的蜘蛛朋友变成蜘蛛战士。",		-- 物品名:"战士变身涂鸦" 制造描述:"做最可爱的小保镖。"
		MUTATOR_DROPPER = "怪物曲奇饼，让韦伯的蜘蛛朋友变成穴居悬蛛。",		-- 物品名:"悬蛛变身涂鸦" 制造描述:"味道也许会让你惊喜。"
		MUTATOR_HIDER = "怪物曲奇饼，让韦伯的蜘蛛朋友变成洞穴蜘蛛。",		-- 物品名:"洞穴变身涂鸦" 制造描述:"外酥里嫩。"
		MUTATOR_SPITTER = "怪物曲奇饼，让韦伯的蜘蛛朋友变成喷射蜘蛛。",		-- 物品名:"喷吐变身涂鸦" 制造描述:"喷薄而出的蜘蛛形象。"
		MUTATOR_MOON = "怪物曲奇饼，让韦伯的蜘蛛朋友变成破碎蜘蛛。",		-- 物品名:"破碎变身涂鸦" 制造描述:"吃到它的人会快乐到月球去！"
		MUTATOR_HEALER = "怪物曲奇饼，让韦伯的蜘蛛朋友变成护士蜘蛛。",		-- 物品名:"护士变身涂鸦" 制造描述:"特别多的谷物，所以必须是健康的！"
		-- 薇格福德，女武神
		WATHGRITHR =
		{
			GENERIC = "日安，%s！",		-- 物品名:"薇格弗德"->默认
			ATTACKER = "有可能的话，我会躲开%s的拳头。",		-- 物品名:"薇格弗德"->攻击队友
			MURDERER = "%s变得狂暴！",		-- 物品名:"薇格弗德"->杀死队友
			REVIVER = "%s精神饱满。",		-- 物品名:"薇格弗德"->复活队友
			GHOST = "做的不错。你还没逃离英灵殿呢，%s。",		-- 物品名:"薇格弗德"->死了
			FIRESTARTER = "%s是个加热好手。",		-- 物品名:"薇格弗德"->烧家
		},
		SPEAR_WATHGRITHR = "王于兴师，修我矛戟，与子偕作！",		-- 物品名:"战斗长矛" 制造描述:"黄金使它更锋利。"
		WATHGRITHRHAT = "王于兴师，修我甲兵，与子偕行！",		-- 物品名:"战斗头盔" 制造描述:"独角兽是你的保护神。"
		WATHGRITHR_IMPROVEDHAT = "至少它确实可靠。",	--物品名:"统帅头盔" 制造描述:"适合女武神女王的头盔。"
		SPEAR_WATHGRITHR_LIGHTNING = "金霆裂苍云，掷电贯风雷。",	--物品名:"奔雷矛" 制造描述:"闪电的力量由你掌控。"
		WATHGRITHR_SHIELD = "以守代攻。",	--物品名:"战斗圆盾" 制造描述:"只要它相信自己，盾牌也可以是武器。"
		SADDLE_WATHGRITHR = "如虎添翼。",	--物品名:"战斗鞍具" 制造描述:"勇士与坐骑，一起战斗吧！"
		
		BATTLESONG_CONTAINER = "战歌的容器。",	--物品名:"战斗号子罐" 制造描述:"保存你所有的金曲。"
		BATTLESONG_DURABILITY = "击石拊石，百兽率舞。",		-- 物品名:"武器化的颤音" 制造描述:"让武器有更多的时间成为焦点。"
		BATTLESONG_HEALTHGAIN = "哀声彻谷，百战皆兴。",		-- 物品名:"心碎歌谣" 制造描述:"一首偷心的颂歌。"
		BATTLESONG_SANITYGAIN = "冰弦破妄，灵台覆镜。",		-- 物品名:"醍醐灌顶华彩" 制造描述:"用歌声慰藉你的心灵。"
		BATTLESONG_SANITYAURA = "金声裂云，铁胆自成。",		-- 物品名:"英勇美声颂" 制造描述:"无所畏惧！"
		BATTLESONG_FIRERESISTANCE = "万舌灼灼，气凝玄冰。",		-- 物品名:"防火假声" 制造描述:"抵御火辣的戏评人。"
		BATTLESONG_INSTANT_TAUNT = "千军辟易，不惊麟辈。",		-- 物品名:"粗鲁插曲" 制造描述:"用言语扔一个番茄。"
		BATTLESONG_INSTANT_PANIC = "幽墟魇语，万灵俱慑。",		-- 物品名:"惊心独白" 制造描述:"如此出色的表演，就问你怕不怕。"
		BATTLESONG_INSTANT_REVIVE = "战歌未彻魂幡曳，残甲重聚故人声。",	--物品名:"战士重奏" 制造描述:"扰动阵亡战友的心房。"
		BATTLESONG_SHADOWALIGNED = "通过歌颂黑暗获得些许赐福。",	--物品名:"黑暗悲歌" 制造描述:"减少自身和盟友受到暗影攻击的伤害，增加对月亮阵营敌人的伤害。"
		BATTLESONG_LUNARALIGNED = "通过歌颂月神获得些许赐福。",	--物品名:"启迪摇篮曲" 制造描述:"减少自身和盟友受到月亮攻击的伤害，增加对暗影阵营敌人的伤害。"
		-- 薇落娜，女工
		WINONA =
		{
			GENERIC = "日安，%s！",		-- 物品名:"薇诺娜"->默认
			ATTACKER = "%s是安全隐患.",		-- 物品名:"薇诺娜"->攻击队友
			MURDERER = "到此为止了，%s！",		-- 物品名:"薇诺娜"->杀死队友
			REVIVER = "你可真是方便好用啊，%s。",		-- 物品名:"薇诺娜"->复活队友
			GHOST = "好像有人在给你的计划泼冷水呢。",		-- 物品名:"薇诺娜"->死了
			FIRESTARTER = "工厂的东西烧起来了。",		-- 物品名:"薇诺娜"->烧家
		},
		SEWING_TAPE = "质量更好的虽然是一次性的，但是能用在更多地方。",		-- 物品名:"可靠的胶布" 制造描述:"缝补受损的衣物。"
		INSPECTACLESBOX = "only_used_by_winona",	-- 物品名:"藏物箱"
		INSPECTACLESBOX2 = "only_used_by_winona",	-- 物品名:"高级藏物箱"
		-- 检查专用镜
		INSPECTACLESHAT = 
		{
			GENERIC = "愿她能找到真正的自己。",	-- 物品名:"检查专用镜"->默认 制造描述:"与你的老上司保持一致的波谱。"
			MISSINGSKILL = "only_used_by_winona",	-- 物品名:"检查专用镜"->无天赋 制造描述:"与你的老上司保持一致的波谱。"
		},
		WINONA_MACHINEPARTS_1 = "only_used_by_winona",	-- 物品名:"小玩意"
		WINONA_MACHINEPARTS_2 = "only_used_by_winona",	-- 物品名:"小机械"
		WINONA_RECIPESCANNER = "only_used_by_winona",	-- 物品名:"校准观察机"
		WINONA_HOLOTELEPAD = "only_used_by_winona",	-- 物品名:"不稳定传输"
		WINONA_HOLOTELEBRELLA = "only_used_by_winona",	-- 物品名:"不稳定传输"
		-- 玫瑰色眼镜
		ROSEGLASSESHAT =
		{
			GENERIC = "跟薇诺娜一贯的风格多少有些出入。",	-- 物品名:"玫瑰色眼镜"->默认 制造描述:"透过新的镜片看事情，找查理。"
			MISSINGSKILL = "only_used_by_winona",	-- 物品名:"玫瑰色眼镜"->无天赋 制造描述:"透过新的镜片看事情，找查理。"
		},
		CHARLIERESIDUE = "only_used_by_winona",	-- 物品名:"黑暗痕迹"
		CHARLIEROSE = "only_used_by_winona",	-- 物品名:"脆弱玫瑰"
		-- 趁手遥控器
		WINONA_REMOTE =
		{
			GENERIC = "远程操纵。",	-- 物品名:"称手遥控器"->默认 制造描述:"只需按下按钮，即可控制您的创造物。"
			OFF = "看起来它需要足够的能源。",	-- 物品名:"称手遥控器"->没电 制造描述:"只需按下按钮，即可控制您的创造物。"
			CHARGING = "远程操纵。",	-- 物品名:"称手遥控器"->充电中 制造描述:"只需按下按钮，即可控制您的创造物。"
			CHARGED = "远程操纵。",	-- 物品名:"称手遥控器"->充电完毕 制造描述:"只需按下按钮，即可控制您的创造物。"
		},
		-- 传送伞
		WINONA_TELEBRELLA =
		{
			GENERIC = "奇特的构思。",	-- 物品名:"传送伞"->默认 制造描述:"将任何东西寄回家的最佳方式是使用粒子。"
			MISSINGSKILL = "only_used_by_winona",	-- 物品名:"传送伞"->无天赋 制造描述:"将任何东西寄回家的最佳方式是使用粒子。"
			OFF = "奇特的构思。",	-- 物品名:"传送伞"->没电 制造描述:"将任何东西寄回家的最佳方式是使用粒子。"
			CHARGING = "奇特的构思。",	-- 物品名:"传送伞"->充电中 制造描述:"将任何东西寄回家的最佳方式是使用粒子。"
			CHARGED = "奇特的构思。",	-- 物品名:"传送伞"->充电完毕 制造描述:"将任何东西寄回家的最佳方式是使用粒子。"
		},
		-- 传送运输站
		WINONA_TELEPORT_PAD_ITEM =
		{
			GENERIC = "她很有天赋，但是还不够。",	-- 物品名:"传送运输站"->默认 制造描述:"在运输物品方面，这台机器真的能送到。"
			MISSINGSKILL = "only_used_by_winona",	-- 物品名:"传送运输站"->无天赋 制造描述:"在运输物品方面，这台机器真的能送到。"
			OFF = "看起来它需要足够的能源。",	-- 物品名:"传送运输站"->没电 制造描述:"在运输物品方面，这台机器真的能送到。"
			BURNING = "得帮薇诺娜做点什么。",	-- 物品名:"传送运输站"->燃烧 制造描述:"在运输物品方面，这台机器真的能送到。"
			BURNT = "可惜了···",	-- 物品名:"传送运输站"->烧毁 制造描述:"在运输物品方面，这台机器真的能送到。"
		},
		-- 薇器人
		WINONA_STORAGE_ROBOT =
		{
			GENERIC = "全自动机器人。",	-- 物品名:"薇机人"->默认 制造描述:"这位收藏者者应当归于您的收藏。"
			OFF = "难得见你歇息。",	-- 物品名:"薇机人"->没电 制造描述:"这位收藏者者应当归于您的收藏。"
			SLEEP = "全自动机器人。",	-- 物品名:"薇机人"->休眠 制造描述:"这位收藏者者应当归于您的收藏。"
			CHARGING = "难得见你歇息。",	-- 物品名:"薇机人"->充电中 制造描述:"这位收藏者者应当归于您的收藏。"
			CHARGED = "难得见你歇息。",	-- 物品名:"薇机人"->充电完毕 制造描述:"这位收藏者者应当归于您的收藏。"
		},
		-- 投石机
		WINONA_CATAPULT =
		{
			GENERIC = "巧手的工人制造的一种自动防卫系统。",		-- 物品名:"薇诺娜的投石机"->默认 制造描述:"向敌人投掷大石块"
			OFF = "看起来它需要足够的能源。",		-- 物品名:"薇诺娜的投石机"->关闭 制造描述:"向敌人投掷大石块"
			BURNING = "得帮薇诺娜做点什么。",		-- 物品名:"薇诺娜的投石机"->正在燃烧 制造描述:"向敌人投掷大石块"
			BURNT = "可惜了···",		-- 物品名:"薇诺娜的投石机"->烧焦的 制造描述:"向敌人投掷大石块"
			SLEEP = "巧手的工人制造的一种自动防卫系统。",	-- 物品名:"薇诺娜的投石机"->休眠 制造描述:"向敌人投掷大石块"
		},
		-- 聚光灯
		WINONA_SPOTLIGHT =
		{
			GENERIC = "谁都可以是主角。",		-- 物品名:"薇诺娜的聚光灯"->默认 制造描述:"白天夜里都发光"
			OFF = "看起来它需要足够的能源。",		-- 物品名:"薇诺娜的聚光灯"->关闭 制造描述:"白天夜里都发光"
			BURNING = "得帮薇诺娜做点什么。",		-- 物品名:"薇诺娜的聚光灯"->正在燃烧 制造描述:"白天夜里都发光"
			BURNT = "可惜了···",		-- 物品名:"薇诺娜的聚光灯"->烧焦的 制造描述:"白天夜里都发光"
			SLEEP = "幕后的功臣也需要休息。",	-- 物品名:"薇诺娜的聚光灯"->休眠 制造描述:"白天夜里都发光"
		},
		-- 硝石发电机
		WINONA_BATTERY_LOW =
		{
			GENERIC = "燃烧能源，输出电力。",		-- 物品名:"薇诺娜的发电机"->默认 制造描述:"要确保电力供应充足"
			LOWPOWER = "看来没有电了。",		-- 物品名:"薇诺娜的发电机"->没电了 制造描述:"要确保电力供应充足"
			OFF = "也许我可以试试帮帮忙。",		-- 物品名:"薇诺娜的发电机"->关闭 制造描述:"要确保电力供应充足"
			BURNING = "得帮薇诺娜做点什么。",		-- 物品名:"薇诺娜的发电机"->正在燃烧 制造描述:"要确保电力供应充足"
			BURNT = "可惜了···",		-- 物品名:"薇诺娜的发电机"->烧焦的 制造描述:"要确保电力供应充足"
		},
		-- 宝石发电机
		WINONA_BATTERY_HIGH =
		{
			GENERIC = "宝石中也有另一种形式的能源。",		-- 物品名:"薇诺娜的宝石发电机"->默认 制造描述:"这玩意烧宝石，所以肯定不会差。"
			LOWPOWER = "看来没有电了。",		-- 物品名:"薇诺娜的宝石发电机"->没电了 制造描述:"这玩意烧宝石，所以肯定不会差。"
			OFF = "让它歇会。",		-- 物品名:"薇诺娜的宝石发电机"->关闭 制造描述:"这玩意烧宝石，所以肯定不会差。"
			BURNING = "得帮薇诺娜做点什么。",		-- 物品名:"薇诺娜的宝石发电机"->正在燃烧 制造描述:"这玩意烧宝石，所以肯定不会差。"
			BURNT = "可惜了···",		-- 物品名:"薇诺娜的宝石发电机"->烧焦的 制造描述:"这玩意烧宝石，所以肯定不会差。"
			OVERLOADED = "得让它冷静下来。",	-- 物品名:"薇诺娜的宝石发电机"->超载 制造描述:"这玩意烧宝石，所以肯定不会差。"
		},
		-- 沃拓克斯，小恶魔
		WORTOX =
		{
			GENERIC = "你好，%s！",		-- 物品名:"沃拓克斯"->默认
			ATTACKER = "我就知道%s不可信！",		-- 物品名:"沃拓克斯"->攻击队友
			MURDERER = "是时候正面对抗这个长角的恶魔了！",		-- 物品名:"沃拓克斯"->杀死队友
			REVIVER = "多谢你的援助之爪%s。",		-- 物品名:"沃拓克斯"->复活队友
			GHOST = "我拒绝接受有鬼魂和恶魔的现实。",		-- 物品名:"沃拓克斯"->死了
			FIRESTARTER = "%s正在变成一个生存的负担。",		-- 物品名:"沃拓克斯"->烧家
		},
		WORTOX_SOUL = "only_used_by_wortox", -- 灵魂
		
		WORMWOOD =
		{
			GENERIC = "你好，%s！",		-- 物品名:"沃姆伍德"->默认
			ATTACKER = "%s今天似乎比平时更多刺。",		-- 物品名:"沃姆伍德"->攻击队友
			MURDERER = "准备被除草吧，小杂草，%s!",		-- 物品名:"沃姆伍德"->杀死队友
			REVIVER = "%s从来不会放弃他的朋友。",		-- 物品名:"沃姆伍德"->复活队友
			GHOST = "需要一些帮助吧，小伙伴？",		-- 物品名:"沃姆伍德"->死了
			FIRESTARTER = "我以为你讨厌火，%s.",		-- 物品名:"沃姆伍德"->烧家
		},
		COMPOSTWRAP = "奇特的堆肥方法。",		-- 物品名:"肥料包" 制造描述:"\"草本\"的疗法。"
		ARMOR_BRAMBLE = "防守是最好的进攻。",		-- 物品名:"荆棘外壳" 制造描述:"让大自然告诉你什么叫\"滚开\"。"
		TRAP_BRAMBLE = "植物的反击。",		-- 物品名:"荆棘陷阱" 制造描述:"都有机会中招的干\n扰陷阱。"
		ARMOR_LUNARPLANT_HUSK = "攻守兼备。",	--物品名:"荆棘茄甲" 制造描述:"这次下次，浑身带刺。"
		IPECACSYRUP = "绝对的恶作剧。",	-- 物品名:"吐根糖浆" 制造描述:"让你保持正常。"
		--沃利，大厨
		WARLY =
		{
			GENERIC = "你好，%s！",		-- 物品名:"沃利"->默认
			ATTACKER = "酝酿着灾难。",		-- 物品名:"沃利"->攻击队友
			MURDERER = "别打杀我的主意！",		-- 物品名:"沃利"->杀死队友
			REVIVER = "总是可以指望%s来做一个计划。",		-- 物品名:"沃利"->复活队友
			GHOST = "它现在用幽灵辣椒做饭吧。",		-- 物品名:"沃利"->死了
			FIRESTARTER = "他会把这个地方都烧了！",		-- 物品名:"沃利"->烧家
		},
		-- 便携烹饪锅
		PORTABLECOOKPOT_ITEM =
		{
			GENERIC = "专业烹饪锅。",		-- 物品名:"便携烹饪锅"->默认 制造描述:"随时随地为美食家服务。"
			DONE = "手艺不错嘛。",		-- 物品名:"便携烹饪锅"->完成了 制造描述:"随时随地为美食家服务。"

			COOKING_LONG = "耐心。",		-- 物品名:"便携烹饪锅"->饭还需要很久 制造描述:"随时随地为美食家服务。"
			COOKING_SHORT = "马上就好。",		-- 物品名:"便携烹饪锅"->饭快做好了 制造描述:"随时随地为美食家服务。"
			EMPTY = "交给专业厨师来用。",		-- 物品名:"便携烹饪锅"->空的 制造描述:"随时随地为美食家服务。"
		},
		-- 便携调味盘
		PORTABLESPICER_ITEM =
		{
			GENERIC = "增加特色风味。",		-- 物品名:"便携香料站"->默认 制造描述:"调味让饭菜更可口。"
			DONE = "更美味了。",		-- 物品名:"便携香料站"->完成了 制造描述:"调味让饭菜更可口。"
		},
		SPICEPACK = "密封良好的食物存储容器。",		-- 物品名:"厨师袋" 制造描述:"使你的食物保持新鲜。"
		PORTABLEBLENDER_ITEM = "可以研磨出调味料。",		-- 物品名:"便携研磨器" 制造描述:"把原料研磨成粉状调味品。"
		-- 沃特，小鱼人
		WURT =
		{
			GENERIC = "日安，%s！",		-- 物品名:"沃特"->默认
			ATTACKER = "%s今天一副凶神恶煞的样子……",		-- 物品名:"沃特"->攻击队友
			MURDERER = "你是条杀人鱼！",		-- 物品名:"沃特"->杀死队友
			REVIVER = "为什么要谢你，%s！",		-- 物品名:"沃特"->复活队友
			GHOST = "%s鱼鳃周围比平时更绿了。",		-- 物品名:"沃特"->死了
			FIRESTARTER = "就没人教你别玩火吗？！",		-- 物品名:"沃特"->烧家
		},
		MERMHAT = "用鱼腥味做伪装。",		-- 物品名:"聪明的伪装" 制造描述:"鱼人化你的朋友。"
		-- 蚊子科技
		MOSQUITOMUSK = "至少不会被这些蚊子叮咬了。",	-- 物品名:"小痒痒" 制造描述:"带上你的小伙伴，混入吸血虫群中。"
		MOSQUITOBOMB = "凶狠的蚊子“炸弹”。",	-- 物品名:"蚊子炸弹" 制造描述:"让每个人都知道“嗡嗡”代表着什么。"
		MOSQUITOFERTILIZER = "味道越臭，营养越高。",	-- 物品名:"嗡嗡肥料" 制造描述:"采用全天然配方。"
		MOSQUITOMERMSALVE = "硬核治疗剂。",	-- 物品名:"蚊血注射液" 制造描述:"为缺铁的鱼人补血，让他们重获新生。"
		-- 食堂海带盘
		OFFERING_POT =
		{
			GENERIC = "看来鱼人王国在闹饥荒。",	--物品名:"食堂海带盘"->默认 制造描述:"一条小海带就能带动很大作用。"
			SOME_KELP = "也许还能再放一些？",	--物品名:"食堂海带盘"->有海带 制造描述:"一条小海带就能带动很大作用。"
			LOTS_OF_KELP = "岁丰年稔。",	--物品名:"食堂海带盘"->装满海带 制造描述:"一条小海带就能带动很大作用。"
		},
		-- 高级食堂海带盘
		OFFERING_POT_UPGRADED =
		{
			GENERIC = "看来鱼人王国在闹饥荒。",	--物品名:"高级食堂海带盘"->默认 制造描述:"一大堆海带能带动更大的作用。"
			SOME_KELP = "也许还能再放一些？",	--物品名:"高级食堂海带盘"->有海带 制造描述:"一大堆海带能带动更大的作用。"
			LOTS_OF_KELP = "岁丰年稔。",	--物品名:"高级食堂海带盘"->装满海带 制造描述:"一大堆海带能带动更大的作用。"
		},
		MERM_ARMORY = "按甲休兵。",	--物品名:"鱼人军械库" 制造描述:"没有一顶合适的头盔，人鱼就不应该冲锋陷阵。"
		MERM_ARMORY_UPGRADED = "载戢干戈。",	--物品名:"高级鱼人军械库" 制造描述:"专为对战斗头盔有独特品味的鱼人设计。"
		MERM_TOOLSHED = "制造工艺有待提升。",	--物品名:"劣质工具棚" 制造描述:"鱼欲善其事，必先利其器。"
		MERM_TOOLSHED_UPGRADED = "至少比以前好点。",	--物品名:"不那么劣质的工具棚" 制造描述:"最好的鱼工精神需要最好的工具。"
		MERMARMORHAT = "只适合鱼人。",	--物品名:"沼泽斗士头盔"
		MERMARMORUPGRADEDHAT = "为鱼人定制。",	--物品名:"沼泽斗士头盔"
		MERM_TOOL = "简单，但是有效。",	--物品名:"劣质工具"
		MERM_TOOL_UPGRADED = "技术有所进步。",	--物品名:"不那么劣质的工具"

		WURT_SWAMPITEM_SHADOW = "简陋的暗影魔法，但是有效。",	--物品名:"绝望投泥带" 制造描述:"为任何战斗带来主场优势，以及一些蠕动的援军。"
		WURT_SWAMPITEM_LUNAR = "简陋的月亮魔法，但是有效。",	--物品名:"光芒投泥带" 制造描述:"让一声令人身心变异的巨响彻底改变战场和您无畏的追随者吧！"

		MERM_SHADOW = "饱含梦魇力量的鱼人亡魂。",	--物品名:"暗影鱼人"
		MERMGUARD_SHADOW = "在它意识被吞没前，它依旧忠于鱼人王国。",	--物品名:"暗影鱼人守卫"

		MERM_LUNAR = "被月裔改造并不是什么好事。",	--物品名:"变异鱼人"
		MERMGUARD_LUNAR = "空有残躯。",	--物品名:"变异鱼人守卫"
		-- 皇家地毯(完成)
		MERMTHRONE =
		{
			GENERIC = "看起来还算奢华。",		-- 物品名:"皇家地毯"->默认
			BURNT = "即使在潮湿的沼泽也难逃火焰的席卷。",		-- 物品名:"皇家地毯"->烧焦的
		},
		-- 皇家手工套装(未完成)
		MERMTHRONE_CONSTRUCTION =
		{
			GENERIC = "建立一个王朝，需要付出的还有很多。",		-- 物品名:"皇家手工套装"->默认 制造描述:"建立一个新的鱼人王朝。"
			BURNT = "中道崩殂。",		-- 物品名:"皇家手工套装"->烧焦的 制造描述:"建立一个新的鱼人王朝。"
		},
		-- 鱼人工艺屋
		MERMHOUSE_CRAFTED =
		{
			GENERIC = "比之前的摇晃房间要好得多。",		-- 物品名:"鱼人工艺屋"->默认 制造描述:"适合鱼人的家。"
			BURNT = "没有规划好防火措施。",		-- 物品名:"鱼人工艺屋"->烧焦的 制造描述:"适合鱼人的家。"
		},
		-- 有无鱼人王区别
		MERMWATCHTOWER_REGULAR = "率土之滨，莫非王臣。",		-- 物品名:"鱼人堡垒" 制造描述:"适合鱼人的家。"
		MERMWATCHTOWER_NOKING = "它们缺少一个主心骨。",		-- 物品名:"鱼人堡垒" 制造描述:"适合鱼人的家。"
		MERMKING = "欲戴王冠,必承其重。",		-- 物品名:"鱼人之王"
		MERMGUARD = "王室禁卫。",		-- 物品名:"忠诚鱼人守卫"
		MERM_PRINCE = "它还未真正加冕。",		-- 物品名:"过程中的皇室"

		WALTER =
		{
			GENERIC = "日安，%s！",		-- 物品名:"沃尔特"->默认
			ATTACKER = "这是松树先锋队员该做的事吗？",		-- 物品名:"沃尔特"->攻击队友
			MURDERER = "你的故事素材用完了吗，%s？",		-- 物品名:"沃尔特"->杀死队友
			REVIVER = "%s永远靠谱。",		-- 物品名:"沃尔特"->复活队友
			GHOST = "我知道你玩的很开心，但是我们要去找一颗心。",		-- 物品名:"沃尔特"->死了
			FIRESTARTER = "那个看起来可不像是营火，%s。",		-- 物品名:"沃尔特"->烧家
		},
		 -- 沃比(骑乘形态)
		WOBYBIG =
		{
			"呵，长大了。",		-- 物品名:"沃比"->巨型状态
			"呵，长大了。",		-- 物品名:"沃比"->巨型状态
		},
		-- 沃比(随从形态)
		WOBYSMALL =
		{
			"可爱的小狗。",		-- 物品名:"沃比"->小型状态
			"可爱的小狗。",		-- 物品名:"沃比"->小型状态
		},
		WALTERHAT = "充满活力与干劲的制作。",		-- 物品名:"松树先锋队帽子" 制造描述:"形式和功能高于时尚。"
		--  弹弓
		SLINGSHOT = "小孩子的把戏。",             --  可靠的弹弓
		SLINGSHOTMODKIT = "小孩的把戏。",         --  改装包
		SLINGSHOT_BAND_PIGSKIN = "小孩的把戏。",  --  猪皮弓带
		SLINGSHOT_BAND_TENTACLE = "小孩的把戏。", --  甩尾弓带(触手皮)
		SLINGSHOT_BAND_MIMIC = "小孩的把戏。",    --  附身弓带(宝箱怪转换版)
		SLINGSHOT_FRAME_BONE = "小孩的把戏。",    --  骨架弓架
		SLINGSHOT_FRAME_GEMS = "小孩的把戏。",    --  铥矿弓架
		SLINGSHOT_FRAME_WAGPUNK_0 = "小孩的把戏。", --  废料弓架
		SLINGSHOT_FRAME_WAGPUNK = "小孩的把戏。",   --  加量废料弓架
		SLINGSHOT_HANDLE_STICKY = "小孩的把戏。",   --  弹弓手柄缠带(蛛丝)
		SLINGSHOT_HANDLE_JELLY = "小孩的把戏。",    --  粘性弹弓手柄(格罗姆粘液)
		SLINGSHOT_HANDLE_SILK = "小孩的把戏。",     --  蜂王浆手柄
		SLINGSHOT_HANDLE_VOIDCLOTH = "小孩的把戏。", --  虚空手柄
		--  弹药
		SLINGSHOTAMMO_ROCK = "羸弱的玩具。",		         -- 鹅卵石
		SLINGSHOTAMMO_MARBLE = "杀伤力尚可。",		         -- 大理石弹
		SLINGSHOTAMMO_THULECITE = "粗浅但实用的巫术。",	     -- 诅咒弹药
        SLINGSHOTAMMO_GOLD = "我喜欢这种奢靡，但是华而不实。", -- 黄金弹药
        SLINGSHOTAMMO_SLOW = "效果不错。",		             -- 减速弹药(紫宝石弹)
        SLINGSHOTAMMO_FREEZE = "没能完全发挥宝石的魔力。",    -- 冰冻弹药
		SLINGSHOTAMMO_POOP = "恶心。",		                -- 便便弹
		SLINGSHOTAMMO_HONEY = "粘稠的甜蜜。",                -- 黏黏弹(蜂蜜弹)
		SLINGSHOTAMMO_STINGER = "废物利用。",                -- 蜂刺弹
		SLINGSHOTAMMO_MOONGLASS = "代表月亮的惩罚？",        -- 月亮玻璃弹
		SLINGSHOTAMMO_GELBLOB = "足够缠人。",                -- 恶液弹
		SLINGSHOTAMMO_SCRAPFEATHER = "居然带电？",           -- 废料弹
        SLINGSHOTAMMO_DREADSTONE = "硬的令人绝望。",         -- 绝望石弹
        SLINGSHOTAMMO_GUNPOWDER = "划时代的武器。",           -- 轰轰弹(火药爆炸弹)
        SLINGSHOTAMMO_LUNARPLANTHUSK = "它还保有微弱的生物活性。", -- 亮茄弹
        SLINGSHOTAMMO_PUREBRILLIANCE = "天光大亮。",         -- 纯粹辉煌弹
        SLINGSHOTAMMO_HORRORFUEL = "恶灵缠身。",             -- 纯粹恐惧弹
		--  弹药袋
		SLINGSHOTAMMO_CONTAINER = "随身活力支援。",
		--  帐篷
		PORTABLETENT = "更结实便携的帐篷。",		-- 物品名:"宿营帐篷" 制造描述:"便捷的保护设备，让你免受风吹雨打。"
		PORTABLETENT_ITEM = "随时随地入梦。",		-- 物品名:"帐篷卷" 制造描述:"便捷的保护设备，让你免受风吹雨打。"

		WOBY_TREAT = "一种粗制狗粮。",          --  沃比零食
		BANDAGE_BUTTERFLYWINGS = "急性救护。", --  蝴蝶翅膀绷带
		PORTABLEFIREPIT_ITEM = "随身火堆。",   --  便携火堆。
		
		WANDA =
		{
			GENERIC = "日安，%s！",		-- 物品名:"旺达"->默认
			ATTACKER = "不要这么不分时间，不分场合，%s！",		-- 物品名:"旺达"->攻击队友
			MURDERER = "杀人犯！我绝不会给你第二次机会的！",		-- 物品名:"旺达"->杀死队友
			REVIVER = "要不是%s，我就成为历史了！",		-- 物品名:"旺达"->复活队友
			GHOST = "赶紧去找颗心脏。",		-- 物品名:"旺达"->死了
			FIRESTARTER = "让我猜猜，这与“保存时间线”有关？",		-- 物品名:"旺达"->烧家
		},
		POCKETWATCH_PARTS = "时间的残骸。",		-- 物品名:"时间碎片" 制造描述:"计时必备零件。"
		POCKETWATCH_DISMANTLER = "自己动手，丰衣足食。",		-- 物品名:"钟表匠工具" 制造描述:"修补计时装置。"
		-- 不老表
		POCKETWATCH_HEAL = {
			GENERIC = "如此逍遥，好不快活。",		-- 物品名:"不老表"->默认 制造描述:"你觉得自己是几岁，你就是几岁。"
			RECHARGING = "时间本身也需要时间。",		-- 物品名:"不老表"->冷却中 制造描述:"你觉得自己是几岁，你就是几岁。"
		},
		-- 第二次机会表
		POCKETWATCH_REVIVE = {
			GENERIC = "再来一次，结局也许会有所不同。",		-- 物品名:"第二次机会表"->默认 制造描述:"挽回一个朋友的不幸结局。"
			RECHARGING = "时间本身也需要时间。",		-- 物品名:"第二次机会表"->冷却中 制造描述:"挽回一个朋友的不幸结局。"
		},
		-- 倒走表
		POCKETWATCH_WARP = {
			GENERIC = "回首相约岁月老，山河转眼瘦沙时。",		-- 物品名:"倒走表"->默认 制造描述:"重走你的最后几步。"
			RECHARGING = "时间本身也需要时间。",		-- 物品名:"倒走表"->冷却中 制造描述:"重走你的最后几步。"
		},
		-- 溯源表
		POCKETWATCH_RECALL = {
			GENERIC = "不要忘记你原本的目的地。",		-- 物品名:"溯源表"->默认 制造描述:"返回到一个遥远的时间点。"
			RECHARGING = "时间本身也需要时间。",		-- 物品名:"溯源表"->冷却中 制造描述:"返回到一个遥远的时间点。"
			UNMARKED = "only_used_by_wanda",		-- 物品名:"溯源表"（旺达专用） 制造描述:"返回到一个遥远的时间点。"
			MARKED_SAMESHARD = "only_used_by_wanda",		-- 物品名:"溯源表"（旺达专用） 制造描述:"返回到一个遥远的时间点。"
			MARKED_DIFFERENTSHARD = "only_used_by_wanda",		-- 物品名:"溯源表"（旺达专用） 制造描述:"返回到一个遥远的时间点。"
		},
		-- 裂隙表
		POCKETWATCH_PORTAL = {
			GENERIC = "想要去哪里？",		-- 物品名:"裂缝表"->默认 制造描述:"和朋友一起穿越时间会更好。"
			RECHARGING = "时间本身也需要时间。",		-- 物品名:"裂缝表"->冷却中 制造描述:"和朋友一起穿越时间会更好。"
			UNMARKED = "only_used_by_wanda unmarked",		-- 物品名:"裂缝表"（旺达专用） 制造描述:"和朋友一起穿越时间会更好。"
			MARKED_SAMESHARD = "only_used_by_wanda other shard",		-- 物品名:"裂缝表"（旺达专用） 制造描述:"和朋友一起穿越时间会更好。"
			MARKED_DIFFERENTSHARD = "only_used_by_wanda other shard",		-- 物品名:"裂缝表"（旺达专用） 制造描述:"和朋友一起穿越时间会更好。"
		},
		-- 时间裂隙(裂隙表开的通道)
		POCKETWATCH_PORTAL_ENTRANCE = 
		{
			GENERIC = "这一梦，又会去往何处？",		-- 物品名:"时间裂缝"->默认
			DIFFERENTSHARD = "这一梦，又会去往何处？",		-- 物品名:"时间裂缝"->跨世界
		},
		POCKETWATCH_PORTAL_EXIT = "不要向外侧看。",		-- 物品名:"时间裂缝"
		-- 警钟
		POCKETWATCH_WEAPON = {
			GENERIC = "警钟长鸣。",		-- 物品名:"警告表"->默认 制造描述:"这只钟敲的就是你。"
			DEPLETED = "only_used_by_wanda",		-- 物品名:"警告表"（旺达专用） 制造描述:"这只钟敲的就是你。"
		},
		-- 芜猴
		WONKEY =
		{
			GENERIC = "是只猴子。",	-- 物品名:"芜猴"->默认
			ATTACKER = "嘿，别像猴子一样胡闹了！",	-- 物品名:"芜猴"->攻击队友
			MURDERER = "它们发猴疯了！",	-- 物品名:"芜猴"->杀死队友
			REVIVER = "我的命居然是……猴子救的？",	-- 物品名:"芜猴"->复活队友
			GHOST = "那只猴子真吓人。",	-- 物品名:"芜猴"->死了
			FIRESTARTER = "恐龙当时是不是就是这种感觉？",	-- 物品名:"芜猴"->烧家
		},
		-- 玩家骸骨
		SKELETON_PLAYER =
		{
			MALE = "看来%s和%s之间有一场不小的摩擦。",		-- 物品名:"骷髅"->男性
			FEMALE = "看来%s和%s之间有一场不小的摩擦。",		-- 物品名:"骷髅"->女性
			ROBOT = "看来%s和%s之间有一场不小的摩擦。",		-- 物品名:"骷髅"->机器人
			DEFAULT = "看来%s和%s之间有一场不小的摩擦。",		-- 物品名:"物品栏物品"->默认
		},
---------- 食物(大部分常规食物，活动专属在活动部分)	----------------------------------------
		WETGOOP = "一塌糊涂。",		-- 物品名:"失败料理"
	------ 素食------------------------------------------------
	------ 食材&烤制
		-- 种子	
		SEEDS = "会种出什么呢？",		-- 物品名:"种子"->普通种子
		SEEDS_COOKED = "烤过以后闻起来不错。",		-- 物品名:"烤种子"
		BERRIES = "红色的浆果，采来酿酒。",		-- 物品名:"浆果"
		BERRIES_COOKED = "烤熟了就不能酿酒了。",		-- 物品名:"烤浆果"
		BERRIES_JUICY = "好多汁水，拿来酿酒最好了！",		-- 物品名:"多汁浆果"
		BERRIES_JUICY_COOKED = "最好在变质前吃掉。",		-- 物品名:"烤多汁浆果"
		ROCK_AVOCADO_FRUIT_RIPE = "像是牛油果。",		-- 物品名:"成熟石果"
		ROCK_AVOCADO_FRUIT_RIPE_COOKED = "味道还可以。",		-- 物品名:"熟石果"
	------ 农作物
		-- 胡萝卜
		CARROT = "卡特斯的最爱。",		-- 物品名:"胡萝卜"
		CARROT_COOKED = "火烤过以后软塌塌的。",		-- 物品名:"烤胡萝卜"
		CARROT_PLANTED = "它又长出来了。",		-- 物品名:"胡萝卜"->植物
		CARROT_SEEDS = "这是一把胡萝卜种子。",		-- 物品名:"椭圆形种子"
		CARROT_OVERSIZED = "硕根蟠赤璎，虬结络地脉。",		-- 物品名:"巨型胡萝卜"
		-- 火龙果
		DRAGONFRUIT = "我记得它是长在某种仙人掌身上的？",		-- 物品名:"火龙果"
		DRAGONFRUIT_COOKED = "被火烤过的“火”。",		-- 物品名:"烤火龙果"
		DRAGONFRUIT_SEEDS = "这是一把火龙果种子。",		-- 物品名:"球茎状种子"
		DRAGONFRUIT_OVERSIZED = "赤璋裂龙甲，星斗坠云浆。",		-- 物品名:"巨型火龙果"
		-- 土豆
		POTATO = "高产的粮食。",		-- 物品名:"土豆"
		POTATO_COOKED = "看着还可以。",		-- 物品名:"烤土豆"
		POTATO_SEEDS = "一把土豆的块茎。",		-- 物品名:"毛茸茸的种子"
		POTATO_OVERSIZED = "金卵孕坤灵，飨世谢厚土。",		-- 物品名:"巨型土豆"
		-- 玉米
		CORN = "我记得在梦里很喜欢这种作物。",		-- 物品名:"玉米"
		CORN_COOKED = "好吃的零食。",		-- 物品名:"爆米花"
		CORN_SEEDS = "这是一把玉米种子。",		-- 物品名:"簇状种子"
		CORN_OVERSIZED = "掰玉露凝霜，炊香动云津。",		-- 物品名:"巨型玉米"
		-- 石榴
		POMEGRANATE = "五月榴花照眼明，枝间时见子初成。",		-- 物品名:"石榴"
		POMEGRANATE_COOKED = "雾壳作房珠作骨，水晶为粒玉为浆。",		-- 物品名:"切片熟石榴"
		POMEGRANATE_SEEDS = "这是一把石榴种子。",		-- 物品名:"风刮来的种子"
		POMEGRANATE_OVERSIZED = "千籽凝霞色，荐瑞酬地灵。",		-- 物品名:"巨型石榴"
		-- 南瓜
		PUMPKIN = "南瓜赤如赭，瓜瓤白如雪。",		-- 物品名:"南瓜"
		PUMPKIN_COOKED = "火候正好，香甜可口。",		-- 物品名:"烤南瓜"
		PUMPKIN_SEEDS = "这是一把南瓜种子。",		-- 物品名:"尖种子"
		PUMPKIN_OVERSIZED = "剖瓤凝玉露，丰岁谢金恩。",		-- 物品名:"巨型南瓜"
		-- 西瓜
		WATERMELON = "碧蔓凌霜卧软沙，年来处处食西瓜。",		-- 物品名:"西瓜"
		WATERMELON_COOKED = "像是年的恶趣味。",		-- 物品名:"烤西瓜"
		WATERMELON_SEEDS = "这是一把西瓜种子。",		-- 物品名:"方形种子"
		WATERMELON_OVERSIZED = "碧穹落星斗，荐此冰玉瓤。",		-- 物品名:"巨型西瓜"
		-- 榴莲
		DURIAN = "流连,但这味道没有人会留恋吧。",		-- 物品名:"榴莲"
		DURIAN_COOKED = "流连,但这味道没有人会留恋吧。",		-- 物品名:"超臭榴莲"
		DURIAN_SEEDS = "这是一把榴莲种子。",		-- 物品名:"脆籽荚"
		DURIAN_OVERSIZED = "香腐夺造化，飨宴动九霄。",		-- 物品名:"巨型榴莲"
		-- 茄子
		EGGPLANT = "紫玉垂霜刃，嘉名唤落苏。",		-- 物品名:"茄子"
		EGGPLANT_COOKED = "紫玉化金酥，燔火煨落苏。",		-- 物品名:"烤茄子"
		EGGPLANT_SEEDS = "这是一把茄子种子。",		-- 物品名:"漩涡种子"
		EGGPLANT_OVERSIZED = "紫玉垂星斗，沉脂坠地脉。",		-- 物品名:"巨型茄子"
		-- 番茄
		TOMATO = "饱满多汁。",		-- 物品名:"番茄"
		TOMATO_COOKED = "也许该打个鸡蛋。",		-- 物品名:"烤番茄"
		TOMATO_SEEDS = "一把番茄的种子。",		-- 物品名:"带刺的种子"
		TOMATO_OVERSIZED = "剖丹凝霞色，荐鼎谢炎阳。",		-- 物品名:"巨型番茄"
		-- 芦笋
		ASPARAGUS = "一种蔬菜。",		-- 物品名:"芦笋"
		ASPARAGUS_COOKED = "感觉还可以。",		-- 物品名:"烤芦笋"
		ASPARAGUS_SEEDS = "这是一把芦笋种子。",		-- 物品名:"筒状种子"
		ASPARAGUS_OVERSIZED = "碧矛破苍穹，撷之荐云飨。",		-- 物品名:"巨型芦笋"
		-- 洋葱
		ONION = "切的时候记得捂住眼睛。",		-- 物品名:"洋葱"
		ONION_COOKED = "烤熟后好闻多了。",		-- 物品名:"烤洋葱"
		ONION_SEEDS = "一把洋葱的种子。",		-- 物品名:"尖形种子"
		ONION_OVERSIZED = "千鳞承月露，剖玉动天容。",		-- 物品名:"巨型洋葱"
		-- 大蒜
		GARLIC = "第一口气清新剂。",		-- 物品名:"大蒜"
		GARLIC_COOKED = "焦黄色，带着浓烈蒜味。",		-- 物品名:"烤大蒜"
		GARLIC_SEEDS = "一把大蒜的种子。",		-- 物品名:"种子荚"
		GARLIC_OVERSIZED = "玉瓣裂坤舆，悬樽辟百邪。",		-- 物品名:"巨型大蒜"
		-- 辣椒
		PEPPER = "火辣辣的。",		-- 物品名:"辣椒"
		PEPPER_COOKED = "更辣了。",		-- 物品名:"烤辣椒"
		PEPPER_SEEDS = "这是一把辣椒种子。",		-- 物品名:"块状种子"
		PEPPER_OVERSIZED = "赤焰坠九阳，衔之宴炎皇。",		-- 物品名:"巨型辣椒"
		-- 大萝卜？ 
		TURNIP = "这是萝卜还是芜菁。",		-- 物品名:"大萝卜"
		TURNIP_COOKED = "闻起来还行",		-- 物品名:"烤大萝卜"
		TURNIP_SEEDS = "一把大萝卜的种子。",		-- 物品名:"圆形种子"
    ------ 蘑菇
		BLUE_CAP = "还很新鲜。",		-- 物品名:"采摘的蓝蘑菇"
		BLUE_CAP_COOKED = "或许不该烤熟它。",		-- 物品名:"烤蓝蘑菇"

		RED_CAP = "红伞伞白杠杆，一看就有毒。",		-- 物品名:"采摘的红蘑菇"
		RED_CAP_COOKED = "烤熟了也还是有毒。",		-- 物品名:"烤红蘑菇"

		GREEN_CAP = "生吃会看到有奇怪的黑影跳舞。",		-- 物品名:"采摘的绿蘑菇"
		GREEN_CAP_COOKED = "烤熟后味道真棒。",		-- 物品名:"烤绿蘑菇"
	------ 其他采集素食
		-- 无花果
		FIG = "很甜。",		-- 物品名:"无花果"
		FIG_COOKED = "味道还不错。",		-- 物品名:"做熟的无花果"
		-- 海带
		KELP = "翠带摇波绿，柔刃剪寒潮。",		-- 物品名:"海带叶"
		KELP_COOKED = "焰纹烙墨玉，咸香化云鳞。",		-- 物品名:"熟海带叶"
		KELP_DRIED = "盐霜凝古褐，风魄锁沧溟。",		-- 物品名:"干海带叶"
		--曼德拉草
		MANDRAKE_PLANTED = "只是看起来可爱，实际上挺烦人的。",		-- 物品名:"曼德拉草"->植物
		MANDRAKE_ACTIVE = "聒噪。",		-- 物品名:"曼德拉草"->叫唤
		MANDRAKE = "现在安静多了。",		-- 物品名:"曼德拉草"->倒地
		MANDRAKE_COOKED = "闻起来还不错，欸，怎么都睡着了。",		-- 物品名:"烤曼德拉草"
		COOKEDMANDRAKE = "可怜的小家伙。",		-- 物品名:"烤曼德拉草"
		MANDRAKESOUP = "或许它有更好的用处？",		-- 物品名:"曼德拉草汤"
		-- 仙人掌
		CACTUS_FLOWER = "美丽的花。",		-- 物品名:"仙人掌花"
		CACTUS_MEAT = "味道并不好吃。",		-- 物品名:"仙人掌肉"
		CACTUS_MEAT_COOKED = "来自大漠的烤水果。",		-- 物品名:"烤仙人掌肉"
		-- 苔藓&蕨类
		LICHEN = "这种蓝藻能在洞穴光线条件下生长。",		-- 物品名:"洞穴苔藓"->植物状态
		CUTLICHEN = "有一定的营养，但不耐储存。",		-- 物品名:"苔藓"->物品
		CAVE_FERN = "暗无天日的地下孕育出的植物，或许可以吃？",		-- 物品名:"蕨类植物"
		FOLIAGE = "一些多叶植物。",		-- 物品名:"蕨叶"
		-- 香蕉
		CAVE_BANANA = "不能乱丢，小心滑倒。",		-- 物品名:"洞穴香蕉"
		CAVE_BANANA_COOKED = "火焰的力量。",		-- 物品名:"烤香蕉"
	------ 通用料理
		JAMMYPRESERVES = "也许该涂在什么食物上。",		-- 物品名:"果酱"
		RATATOUILLE = "营养的减肥餐，但是并不美味。",		-- 物品名:"蔬菜杂烩"
		SWEETTEA = "一盏清魂定，再饮万虑休。",		-- 物品名:"舒缓茶"
		WAFFLES = "早饭的替代品。",		-- 物品名:"华夫饼"
		FLOWERSALAD = "卖相挺不错。",		-- 物品名:"花沙拉"
		TRAILMIX = "酒后闲谈的小零食，味道很不错。",		-- 物品名:"什锦干果"
		FIGATONI = "精致的主食。",		-- 物品名:"无花果意面"
		DRAGONPIE = "很抗饿的饼，甚至用料也很便宜。",		-- 物品名:"火龙果派"
		STUFFEDEGGPLANT = "也许该做成茄包肉？",		-- 物品名:"酿茄子"
		PUMPKINCOOKIE = "茶余酒后浅尝饼，卧亭笑看秋叶红。",		-- 物品名:"南瓜饼干"
		WATERMELONICLE = "消暑的绝佳选择。",		-- 物品名:"西瓜冰棍"
		MASHEDPOTATOES = "软软的土豆泥。",		-- 物品名:"奶油土豆泥"
		POTATOTORNADO = "美味的薯塔。",		-- 物品名:"花式回旋块茎"
		ASPARAGUSSOUP = "温暖的芦笋汤。",		-- 物品名:"芦笋汤"
		SALSA = "辣味小吃。",		-- 物品名:"生鲜萨尔萨酱"
		VEGSTINGER = "不够醇，胜在足够烈。",		-- 物品名:"蔬菜鸡尾酒"
		BANANAPOP = "香蕉冰棒。",		-- 物品名:"香蕉冻"
		BANANAJUICE = "一杯香蕉碎，味道还不错。",	-- 物品名:"香蕉奶昔"
		FROZENBANANADAIQUIRI = "香蕉鸡尾酒。",		-- 物品名:"冰香蕉冻唇蜜"
		FRUITMEDLEY = "制作简单，味道也不错。",		-- 物品名:"水果圣代"

		POWCAKE = "某种程度上的“永恒”，但还是抵不过沧海化桑田的岁月。",		-- 物品名:"永恒芝士蛋糕"
	------ 牛食
		BEEFALOFEED = "还是让我们的丰蹄朋友来吧。",	-- 物品名:"蒸树枝"
		BEEFALOTREAT = "为丰蹄朋友准备的小零食。",	-- 物品名:"皮弗娄牛零食"
	------ 尘蛾食物
		REFINED_DUST = "一大块尘土。",		-- 物品名:"尘土块" 制造描述:"远古甜品的关键原料。"
		DUSTMERINGUE = "奇异的食物。",		-- 物品名:"琥珀美食"
	------ 肉食------------------------------------------------------
	------ 食材&烤制&肉干
		MEAT = "我可不想学樊哙，还是烤熟吃吧。",		-- 物品名:"肉"
		COOKEDMEAT = "烈烤熟彻。",		-- 物品名:"烤大肉"
		MEAT_DRIED = "远足者的必备干粮。",		-- 物品名:"风干肉"

		SMALLMEAT = "小块的肉。",		-- 物品名:"小肉"
		COOKEDSMALLMEAT = "温酒啖肉，好不逍遥。",		-- 物品名:"烤小肉"
		SMALLMEAT_DRIED = "有嚼劲。",		-- 物品名:"小风干肉"
		
		MONSTERMEAT = "这些肉有毒，不能直接吃。",		-- 物品名:"怪物肉"
		COOKEDMONSTERMEAT = "烤熟它纯属多此一举。",		-- 物品名:"烤怪物肉"
		MONSTERMEAT_DRIED = "即使经过晾晒，它还是有毒。",		-- 物品名:"怪物肉干"

		DRUMSTICK = "大块的禽类肉，生吃或许会反胃。",		-- 物品名:"鸟腿"
		DRUMSTICK_COOKED = "味道不错，或许还能继续加工一下。",		-- 物品名:"炸鸟腿"

		TALLBIRDEGG = "好大的蛋，味道应该很不错。",		-- 物品名:"高脚鸟蛋"
		TALLBIRDEGG_COOKED = "美味。",		-- 物品名:"煎高脚鸟蛋"
		
		PLANTMEAT = "素食者的救赎。",		-- 物品名:"叶肉"
		PLANTMEAT_COOKED = "素味的烤肉。",		-- 物品名:"烤叶肉"

		TRUNK_SUMMER = "一光溜溜的象鼻。",		-- 物品名:"象鼻"
		TRUNK_WINTER = "这根象鼻啃看就暖和。",		-- 物品名:"冬象鼻"
		TRUNK_COOKED = "它的鼻子满是肌肉，口感也许不错？",		-- 物品名:"象鼻排"

		BARNACLE = "一点贝类。",		-- 物品名:"藤壶"
		BARNACLE_COOKED = "还凑合。",		-- 物品名:"熟藤壶"
		
		BATWING = "感觉不卫生。",		-- 物品名:"洞穴蝙蝠翅膀"
		BATWING_COOKED = "炽焰，涤尽灾祸。",		-- 物品名:"烤蝙蝠翅膀"

		BATNOSE = "独特的战利品。",		-- 物品名:"裸露鼻孔"
		BATNOSE_COOKED = "也许它有更好的用处？",		-- 物品名:"炭烤鼻孔"
	------ 鱼
		FISH = "授人以鱼不如授人以渔。",		-- 物品名:"鱼"
		PONDFISH = "衔鲜知水暖，入釜作春珍。",		-- 物品名:"淡水鱼"
		FISH_COOKED = "恰到好处。",		-- 物品名:"烤鱼"
		FISHSTICKS = "鲜。",		-- 物品名:"炸鱼排"
		
		FISHMEAT = "整块的鱼肉。",		-- 物品名:"生鱼肉"
		FISHMEAT_COOKED = "恰到好处。",		-- 物品名:"鱼排"
		FISHMEAT_SMALL = "小块鱼肉。",		-- 物品名:"小鱼块"
		FISHMEAT_SMALL_COOKED = "总比没有强。",		-- 物品名:"烤小鱼块"
		SPOILED_FISH = "诶可惜了。",		-- 物品名:"变质的鱼"

		FISHMEAT_DRIED = "鲊熟笋生香满屋，饭香鱼美不论钱。",		-- 物品名:"鱼肉干"
		FISHMEAT_SMALL_DRIED = "晒鱼连日晒檐前，留与儿孙作腊筵。",		-- 物品名:"小鱼肉干"
		-- 鳗鱼
		PONDEEL = "荐醪破幽冥，雷髓润枯肠。",		-- 物品名:"活鳗鱼"
		EEL = "交给幺弟做一道好菜。",		-- 物品名:"死鳗鱼"
		EEL_COOKED = "闻起来真香！",		-- 物品名:"烤鳗鱼"
		UNAGI = "秋肥鳗鲡赛羊羔，膏满肉丰莫等闲。",		-- 物品名:"鳗鱼料理"
    ------ 海鱼
	    -- 生物形式
		OCEANFISH_SMALL_1 = "看起来和孔雀一样美丽的小鱼。",			-- 小孔雀鱼
		OCEANFISH_SMALL_2 = "也许能当墨水用，但是太小了。",			-- 针鼻喷墨鱼
		OCEANFISH_SMALL_3 = "小巧的饵料。",							-- 小饵鱼
		OCEANFISH_SMALL_4 = "看来它没法继续长大了。",				-- 三文鱼苗
		OCEANFISH_SMALL_5 = "嘎嘣脆。",								-- 爆米花鱼
		OCEANFISH_SMALL_6 = "那位居士似乎很想喜欢这种鱼。",			-- 落叶比目鱼
		OCEANFISH_SMALL_7 = "会游动的花朵。",						-- 花朵金枪鱼
		OCEANFISH_SMALL_8 = "太阳的化身。",							-- 炽热太阳鱼
		OCEANFISH_SMALL_9 = "欸哟，别打湿了我的诗集。",				-- "口水鱼
		OCEANFISH_MEDIUM_1 = "看起来很丑。",						-- 泥鱼
		OCEANFISH_MEDIUM_2 = "似乎有只大鸟更喜欢你。",				-- 斑鱼
		OCEANFISH_MEDIUM_3 = "小心尖刺。",							-- 浮夸狮子鱼
		OCEANFISH_MEDIUM_4 = "鱼便是鱼，哪来噩兆之说。",			-- 黑鲶鱼
		OCEANFISH_MEDIUM_5 = "玉麦水中游。",						-- 玉米鳕鱼
		OCEANFISH_MEDIUM_6 = "美丽的锦鲤。",						-- 花锦鲤
		OCEANFISH_MEDIUM_7 = "金色传说。",							-- 金锦鲤
		OCEANFISH_MEDIUM_8 = "更像是活着的冰块。",					 -- 冰鲷鱼
		OCEANFISH_MEDIUM_9 = "长期食用无花果的鱼，已经腌制入味了。",	-- 甜味鱼
		-- 物品形式
		OCEANFISH_SMALL_1_INV = "看起来和孔雀一样美丽的小鱼。",			-- 小孔雀鱼
		OCEANFISH_SMALL_2_INV = "也许能当墨水用，但是太小了。",			-- 针鼻喷墨鱼
		OCEANFISH_SMALL_3_INV = "小巧的饵料。",							-- 小饵鱼
		OCEANFISH_SMALL_4_INV = "看来它没法继续长大了。",				-- 三文鱼苗
		OCEANFISH_SMALL_5_INV = "嘎嘣脆。",								-- 爆米花鱼
		OCEANFISH_SMALL_6_INV = "那位居士似乎很想喜欢这种鱼。",			-- 落叶比目鱼
		OCEANFISH_SMALL_7_INV = "会游动的花朵。",						-- 花朵金枪鱼
		OCEANFISH_SMALL_8_INV = "太阳的化身。",							-- 炽热太阳鱼
		OCEANFISH_SMALL_9_INV = "欸哟，别打湿了我的诗集。",				-- "口水鱼
		OCEANFISH_MEDIUM_1_INV = "看起来很丑。",						-- 泥鱼
		OCEANFISH_MEDIUM_2_INV = "似乎有只大鸟更喜欢你。",				-- 斑鱼
		OCEANFISH_MEDIUM_3_INV = "小心尖刺。",							-- 浮夸狮子鱼
		OCEANFISH_MEDIUM_4_INV = "鱼便是鱼，哪来噩兆之说。",			-- 黑鲶鱼
		OCEANFISH_MEDIUM_5_INV = "玉麦水中游。",						-- 玉米鳕鱼
		OCEANFISH_MEDIUM_6_INV = "美丽的锦鲤。",						-- 花锦鲤
		OCEANFISH_MEDIUM_7_INV = "金色传说。",							-- 金锦鲤
		OCEANFISH_MEDIUM_8_INV = "更像是活着的冰块。",					 -- 冰鲷鱼
		OCEANFISH_MEDIUM_9_INV = "长期食用无花果的鱼，已经腌制入味了。",	-- 甜味鱼
	------ 通用料理
		MEATBALLS = "没什么可挑剔的。",		-- 物品名:"肉丸"
		BONESTEW = "闲暇时，军士们喜欢围火烹汤，真让人怀念。",		-- 物品名:"炖肉汤"
		KABOBS = "简单的烧烤，是漠北的风格。",		-- 物品名:"肉串"
		MONSTERLASAGNA = "味道不比芙蓉小姐的营养餐好。",		-- 物品名:"怪物千层饼"
		JUSTEGGS = "简单的早餐",	-- 物品名:"普通煎蛋"
		BACONEGGS = "完美的早餐，再来一杯酒就完美了。",		-- 物品名:"培根煎蛋"
		VEGGIEOMLET = "一日之计在于晨。",	-- 物品名:"早餐铁锅"
		PEROGIES = "幺弟每年都在等我们回去一起吃饺子，今年总算是结束了。",		-- 物品名:"波兰水饺"
		TALLEGGS = "美味的煎蛋。",	-- 物品名:"高大苏格兰蛋"
		HONEYHAM = "蜂蜜完美的去除了肉的腥味。",		-- 物品名:"蜜汁火腿"
		HONEYNUGGETS = "细细切开的肉块，沾着蜂蜜吃更美味。",		-- 物品名:"蜜汁卤肉"
		HOTCHILI = "年，你又给夕的饭里加辣椒！",		-- 物品名:"辣椒炖肉"
		GUACAMOLE = "为什么要在锅里加入鼹鼠？也许是某种谐音的缘故吧。",		-- 物品名:"鳄梨酱"
		FISHTACOS = "松脆且美味。",		-- 物品名:"鱼肉玉米卷"
		CEVICHE = "看起来有点奇怪，但味道还不错。",		-- 物品名:"酸橘汁腌鱼"
		TURKEYDINNER = "人们并不感恩火鸡。",		-- 物品名:"火鸡大餐"
		BUTTERFLYMUFFIN = "即兴发挥。",		-- 物品名:"蝴蝶松饼"
		PEPPERPOPPER = "只有年会喜欢这么辣的食物。",		-- 物品名:"爆炒填馅辣椒"
		CALIFORNIAROLL = "鲙切霜雪薄，醋饭攒三秋。",		-- 物品名:"加州卷"
		SEAFOODGUMBO = "浓郁的鱼汤。",		-- 物品名:"海鲜浓汤"
		SURFNTURF = "营养均衡的海鲜大餐。",		-- 物品名:"海鲜牛排"
		LOBSTERBISQUE = "一虾三吃，鲜美无比。",		-- 物品名:"龙虾汤"
		LOBSTERDINNER = "丰盛的晚餐。",		-- 物品名:"龙虾正餐"
		FIGKABAB = "万物皆可烤。",		-- 物品名:"无花果烤串"
		KOALEFIG_TRUNK = "及其丰盛。",		-- 物品名:"无花果酿象鼻"
		FROGGLEBUNWICH = "味道还可以。",		-- 物品名:"蛙腿三明治"
		FROGNEWTON = "甜味田鸡三明治。",		-- 物品名:"无花果蛙腿三明治"
		BUNNYSTEW = "兔兔那么可爱，为什么要吃它呢？",		-- 物品名:"炖兔子"
		BARNACLEPITA = "有趣的组合。",		-- 物品名:"藤壶皮塔饼"
		BARNACLESUSHI = "小小的海鲜馅饼。",		-- 物品名:"藤壶握寿司"
		BARNACLINGUINE = "海鲜烩面，江南和北方的结合。",		-- 物品名:"藤壶中细面"
		BARNACLESTUFFEDFISHHEAD = "看起来不太友善啊…",		-- 物品名:"酿鱼头"
		LEAFLOAF = "珍贵的食材做出的平庸糕点。",		-- 物品名:"叶肉糕"
		LEAFYMEATBURGER = "素味快餐。",		-- 物品名:"素食堡"
		LEAFYMEATSOUFFLE = "造型不错，让人眼前一亮。",		-- 物品名:"果冻沙拉"
		MEATYSALAD = "素味沙拉。",		-- 物品名:"牛肉绿叶菜"
		BATNOSEHAT = "颈上套饼，但的确很有创意。",		-- 物品名:"牛奶帽"
		SHROOMBAIT = "强烈的致幻效果。",	-- 物品名:"酿夜帽"
	------ 乳制品&好东西料理
		BUTTER = "这是黄油吗？",		-- 物品名:"黄油"
		ICECREAM = "一口提神醒脑。",		-- 物品名:"冰淇淋"
		TAFFY = "太甜了，甜的齁人。",		-- 物品名:"太妃糖"
		JELLYBEAN = "甜甜的糖豆，蜂王浆的营养浓缩在这些小零食中。",		-- 物品名:"彩虹糖豆"
		SHROOMCAKE = "全菌盛宴。",		-- 物品名:"蘑菇蛋糕"
	------ 调味料
		SALTROCK = "苦涩的海盐。",		-- 物品名:"盐晶"
		SPICE_SALT = "岂是闻韵解忘味，迩来三月食无盐。",		-- 物品名:"调味盐" 制造描述:"为你的饭菜加点咸味。"
		SPICE_GARLIC = "一股蒜味。",		-- 物品名:"蒜粉" 制造描述:"用口臭防守是最好的进攻。"
		SPICE_SUGAR = "令人愉快。",		-- 物品名:"蜂蜜水晶" 制造描述:"令人心平气和的甜美。"
		SPICE_CHILI = "最好不要让年拿到这个…",		-- 物品名:"辣椒面" 制造描述:"刺激十足的粉末。"
	------ 大厨特色菜
		-- 素食
		GLOWBERRYMOUSSE = "蓝色的发光慕斯，吃下去会变成光。",		-- 物品名:"发光浆果慕斯"
		DRAGONCHILISALAD = "希望能承受住辛辣的程度。",		-- 物品名:"辣龙椒沙拉"
		GAZPACHO = "一碗汤便冲走炎炎夏日。",		-- 物品名:"芦笋冷汤"
		NIGHTMAREPIE = "带有魔法的蛋糕。",		-- 物品名:"恐怖国王饼"
		POTATOSOUFFLE = "土豆风味蛋糕。",		-- 物品名:"蓬松土豆蛋奶酥"
		FRESHFRUITCREPES = "奢华的早餐。",		-- 物品名:"鲜果可丽饼"
		-- 肉食
		MONSTERTARTARE = "还是丢了他罢。",		-- 物品名:"怪物鞑靼"
		BONESOUP = "美味的骨头汤。",		-- 物品名:"骨头汤"
		MOQUECA = "舌尖上的海鲜。",		-- 物品名:"海鲜杂烩"
		FROGFISHBOWL = "美味的田鸡海鲜餐。",		-- 物品名:"蓝带鱼排"
		-- 好东西料理
		VOLTGOATJELLY = "带电的果冻。",		-- 物品名:"伏特羊肉冻"
	------ 珍珠的茶
		-- 茶叶
		PETALS_DRIED            = "花香沁腑，提神醒脑。", -- 干燥的花瓣
		PETALS_EVIL_DRIED       = "恶念扰忧，常怀悲叹。", -- 干燥的恶魔花瓣
		FOLIAGE_DRIED           = "聚气凝神，携勇奋敌。", -- 干燥的叶子
		SUCCULENT_PICKED_DRIED  = "静若山莲，无欲清欢。", -- 干燥的多肉植物
		FIRENETTLES_DRIED       = "侵若幽火，满心奋勇", -- 干燥的火荨麻
		TILLWEED_DRIED          = "锄地养精，疗偎心脾。", -- 干燥的犁地草
		MOON_TREE_BLOSSOM_DRIED = "望月明舒，御月而行。", -- 干燥的月树花
		FORGETMELOTS_DRIED      = "泡茶的好材料。", -- 干燥的必忘我
		-- 珍珠的茶
		HERMITCRABTEA_PETALS            = "有提神醒脑。", -- 花瓣茶(少量回san)
		HERMITCRABTEA_PETALS_EVIL       = "恶意低语。", -- 恶魔花瓣茶(扣san)
		HERMITCRABTEA_FOLIAGE           = "相依偕行。", -- 叶子茶(疯狂光环抵抗)
		HERMITCRABTEA_SUCCULENT_PICKED  = "清凉泄火。", -- 多肉茶(降温)
		HERMITCRABTEA_FIRENETTLES       = "一口热茶。", -- 火荨麻茶(升温)
		HERMITCRABTEA_TILLWEED          = "良药苦口。", -- 犁地草茶(少量回血)
		HERMITCRABTEA_MOON_TREE_BLOSSOM = "且看人间。", -- 月树花茶(月灵中立&暗影生物恐慌)
		HERMITCRABTEA_FORGETMELOTS      = "遗忘忧思。", -- 必忘我茶(少量回san)
---------- 作物-------------------------------------------------------------
	------ 食品作物
		-- 浆果丛
		BERRYBUSH =
		{
			BARREN = "我想它需要施肥。",		-- 物品名:"浆果丛"->采摘多次枯萎了
			WITHERED = "赤日炎炎似火烧，野田禾稻半枯焦。",		-- 物品名:"浆果丛"->天热枯萎了
			GENERIC = "野生的浆果从。",		-- 物品名:"浆果丛"->默认
			PICKED = "生长需要时间。",		-- 物品名:"浆果丛"->被采完了
			DISEASED = "看上去病的很重。",--removed		-- 物品名:"浆果丛"->生病了（已移除）
			DISEASING = "呃...有些地方不对劲。",--removed		-- 物品名:"浆果丛"->正在生病（已移除）
			BURNING = "野火。",		-- 物品名:"浆果丛"->正在燃烧
		},
		DUG_BERRYBUSH = "我该将它移植到别处。",		-- 物品名:"浆果丛"->挖出来的
		-- 多汁浆果丛
		BERRYBUSH_JUICY =
		{
			BARREN = "它的根不够深，需要再次施肥。",		-- 物品名:"多汁浆果丛"->采摘多次枯萎了
			WITHERED = "多汁的浆果脱水了。",		-- 物品名:"多汁浆果丛"->天热枯萎了
			GENERIC = "比起吃，更适合酿酒。",		-- 物品名:"多汁浆果丛"->默认
			PICKED = "下一批丛林在努力生长。",		-- 物品名:"多汁浆果丛"->被采完了
			DISEASED = "它看上去很不舒服。",--removed		-- 物品名:"多汁浆果丛"->生病了（已移除）
			DISEASING = "呃...有些地方不对劲。",--removed		-- 物品名:"多汁浆果丛"->正在生病（已移除）
			BURNING = "哎，得赶紧救火。",		-- 物品名:"多汁浆果丛"->正在燃烧
		},
		DUG_BERRYBUSH_JUICY = "种在我的酒坛附近就不错。",		-- 物品名:"多汁浆果丛"->挖出来的
		-- 红蘑菇(土地里)
		RED_MUSHROOM =
		{
			GENERIC = "是红色的、吃完就躺的蘑菇。",		-- 物品名:"红蘑菇"->默认
			INGROUND = "至少你的作息比起另外两种蘑菇正常多了。",		-- 物品名:"红蘑菇"->在地里面
			PICKED = "它的根还在，肯定还能长回来。",		-- 物品名:"红蘑菇"->被采完了
		},
		-- 绿蘑菇(土地里)
		GREEN_MUSHROOM =
		{
			GENERIC = "你的云间清醒梦结束了吗？",		-- 物品名:"绿蘑菇"->默认
			INGROUND = "看来它还没睡醒。",		-- 物品名:"绿蘑菇"->在地里面
			PICKED = "它会长出来的",		-- 物品名:"绿蘑菇"->被采完了
		},
		-- 蓝蘑菇(土地里)
		BLUE_MUSHROOM =
		{
			GENERIC = "蓝色的蘑菇。",		-- 物品名:"蓝蘑菇"->默认
			INGROUND = "白日梦。",		-- 物品名:"蓝蘑菇"->在地里面
			PICKED = "它还会长出来吧。",		-- 物品名:"蓝蘑菇"->被采完了
		},
		-- 香蕉作物
		CAVE_BANANA_TREE = "不知道它是怎么在黑暗的环境中生长的。",		-- 物品名:"洞穴香蕉树"
		CAVE_BANANA_BURNT = "那些猴子要饿肚子了。",		-- 物品名:"洞穴香蕉树"->烧焦的 制造描述:"为你的鸟类朋友提供一个幸福的家。"

		BANANABUSH = "原生的香蕉灌木丛。",	-- 物品名:"香蕉丛"
		DUG_BANANABUSH = "移植的香蕉灌木丛。",	-- 挖出后的香蕉丛
		-- 仙人掌
		CACTUS =
		{
			GENERIC = "极端情况下将士们会食用它补充水分。",		-- 物品名:"仙人掌"->默认
			PICKED = "干瘪了，但还是很多刺。",		-- 物品名:"仙人掌"->被采完了
		},
		-- 石果灌木丛
		-- 注：因为石果的产量远大于石头的产量，所以在此列为食物作物
		ROCK_AVOCADO_BUSH =
		{
			BARREN = "它需要照料。",		-- 物品名:"石果灌木丛"->采集多次枯萎了
			WITHERED = "月亮的魔法也无法抵抗灼热的夏天。",		-- 物品名:"石果灌木丛"->天热枯萎了
			GENERIC = "顽强的植物。",		-- 物品名:"石果灌木丛"->默认
			PICKED = "得过些时间才能结出果实。",		-- 物品名:"石果灌木丛"->被采完了
			DISEASED = "看上去病的很重。", --unimplemented		-- 物品名:"石果灌木丛"->生病了（已移除）
			DISEASING = "呃...有些地方不对劲。", --unimplemented		-- 物品名:"石果灌木丛"->正在生病（已移除）
			BURNING = "可惜它的枝干并不是石头的。",		-- 物品名:"石果灌木丛"->正在燃烧
		},
		ROCK_AVOCADO_FRUIT = "里面有顽强的生命。",		-- 物品名:"石果"
		ROCK_AVOCADO_FRUIT_SPROUT = "从内部打开便是新生。",		-- 物品名:"发芽的石果"
	------ 农作物与杂草
		-- 农作物-新版耕地版本
		FARM_PLANT =
		{
			GENERIC = "那是一株植物！",		-- 物品名:"作物植株"
			SEED = "生根发芽吧。",		-- 物品名:"作物植株"->种子状态
			GROWING = "等它结果，一切都会值得的。",		-- 物品名:"作物植株"->生长中
			FULL = "寒来暑往，秋收冬藏。",		-- 物品名:"作物植株"->成熟
			ROTTEN = "芳华委尘，朽润新芽。",		-- 物品名:"作物植株"->普通作物腐烂
			FULL_OVERSIZED = "汲地脉而化奇珍，酬天恩以硕果。!",		-- 物品名:"作物植株"->巨型作物
			ROTTEN_OVERSIZED = "腐烂的霉运。",		-- 物品名:"作物植株"->巨型作物腐烂
			FULL_WEED = "芜种窃膏腴，偶得酬风露。",		-- 物品名:"作物植株"->杂草
			BURNING = "焚身谢春风，烬落沃芳丛。",		-- 物品名:着火
		},
		-- 农作物-旧版农场版本
		PLANT_NORMAL =
		{
			GENERIC = "枝繁叶茂。",		-- 物品名:"农作物"->默认
			GROWING = "等到它结果，一切都会值得。",		-- 物品名:"农作物"->正在生长
			READY = "寒来暑往，秋收冬藏。",		-- 物品名:"农作物"->成熟了
			WITHERED = "。。。。。。",		-- 物品名:"农作物"->枯萎了
		},
		FARM_SOIL_DEBRIS = "地底下哪来的这么多杂物啊。",		-- 物品名:"农田杂物"
		FIRENETTLES = "衔炎藏叶底，焚肤诫妄触。",		-- 物品名:"火荨麻叶"
		FORGETMELOTS = "芳名必忘我，烹茶涤烦忧。",		-- 物品名:"必忘我"
		TILLWEED = "掀泥泄秽迹，芜根岁岁新。",		-- 物品名:"犁地草"
		WEED_IVY = "感觉是个祸害。",		-- 物品名:"刺针旋花"
		IVY_SNARE = "断不可留。",		-- 物品名:"缠绕根须"
	------ 材料作物
		-- 草
		DEPLETED_GRASS =
		{
			GENERIC = "离离原上草，一岁一枯荣。",		-- 物品名:"草"->枯萎
		},
		-- 草丛
		GRASS =
		{
			BARREN = "离离原上草，一岁一枯荣。",		-- 物品名:"草"->采摘过多枯萎了
			WITHERED = "野火烧不尽，春风吹又生。等秋天它会自己长回来的。",		-- 物品名:"草"->天热枯萎了
			BURNING = "看来它的根也烧起来了。",		-- 物品名:"草"->正在燃烧
			GENERIC = "一个草丛。",		-- 物品名:"草"->默认
			PICKED = "只需要几天时间他就会长回来。",		-- 物品名:"草"->被采完了
		},
		DUG_GRASS = "我该开辟一片种植区了。",		-- 物品名:"草丛"->挖出来的
		 -- 草壁虎
		GRASSGEKKO =
		{
			GENERIC = "一只多叶状蜥蜴？看样子我不用去摘草丛了。",		-- 物品名:"草壁虎"->默认
		},
		-- 小树苗
		SAPLING =
		{
			BURNING = "火焰缠上了它。",		-- 物品名:"树苗"->正在燃烧
			WITHERED = "暑气袭人更袭物。",		-- 物品名:"树苗"->天热枯萎了
			GENERIC = "它会长大吗？",		-- 物品名:"树苗"->默认
			PICKED = "看来你需要重新努力了。",		-- 物品名:"树苗"->被采完了
		},
		DUG_SAPLING = "人们总需要偿还破坏自然的罪孽。",		-- 物品名:"树苗"->挖出来的
		-- 尖刺灌木
		MARSH_BUSH =
		{
			BURNT = "终成灰。",		-- 物品名:"尖刺灌木"->烧焦的
			BURNING = "烽烟起。",		-- 物品名:"尖刺灌木"->正在燃烧
			GENERIC = "费力不讨好。",		-- 物品名:"尖刺灌木"->默认
			PICKED = "等它再长回来吧。",		-- 物品名:"尖刺灌木"->被采完了
		},
		BURNT_MARSH_BUSH = "风会把它带回给这片大地。",		-- 正在燃烧的尖刺灌木
		DUG_MARSH_BUSH = "我该开辟一片种植区了。",		-- 物品名:"尖刺灌木"->挖出来的
		-- 多枝树
		TWIGGYTREE =
		{
			BURNING = "也许该帮帮它。",		-- 物品名:"多枝树"->正在燃烧
			BURNT = "或许还有办法能种一颗出来？",		-- 物品名:"多枝树"->烧焦的
			CHOPPED = "接招吧，大自然！",		-- 物品名:"多枝树"->被砍了
			GENERIC = "很多枝干。",		-- 物品名:"多枝树"->默认
		},
		TWIGGY_NUT = "它蕴育出充满生机和希望的子代。",		-- 物品名:"多枝树种"->多枝树果
		TWIGGY_NUT_SAPLING = "它生长不需要任何助力。",		-- 物品名:"多枝树苗"
		TWIGGY_OLD = "垂垂老矣。",		-- 物品名:"多枝树"->老树
		-- 芦苇
		REEDS =
		{
			BURNING = "燃烧的芦苇荡是多少塔拉人挥之不去的噩梦。",		-- 物品名:"芦苇"->正在燃烧
			GENERIC = "蒹葭苍苍，白露为霜。",		-- 物品名:"芦苇"->默认
			PICKED = "蒹葭萋萋，白露未晞。",		-- 物品名:"芦苇"->被采完了
		},
		-- 猴尾草
		MONKEYTAIL = "看起来像是香蒲。",	-- 物品名:"猴尾草"
		DUG_MONKEYTAIL = "我应该找个地方种下它。",	-- 物品名:"猴尾草"
		-- 大理石树
		MARBLESHRUB = "也许该让黍看看。",		-- 物品名:"大理石灌木"
		MARBLEPILLAR = "古老的遗产，与其在这矗立，不如发挥点你的价值。",		-- 物品名:"大理石柱"
		MARBLETREE = "它似乎是大理石材质的，难道大理石能从地里长出来吗？",		-- 物品名:"大理石树"
---------- 树木	--------------------------------------------------------------------------------
		-- 常青树
		EVERGREEN =
		{
			BURNING = "火云满山凝未开",		-- 物品名:"常青树"->正在燃烧
			BURNT = "一夕烬尽。",		-- 物品名:"常青树"->烧焦的
			CHOPPED = "晴云出岫赋归来，夜雨同心歌伐木。",		-- 物品名:"常青树"->被砍了
			GENERIC = "树下彼何人，不语真吾好。",		-- 物品名:"常青树"->默认
		},
		-- 臃肿/粗壮常青树
		EVERGREEN_SPARSE =
		{
			BURNING = "东西蹶倒山火焚。",		-- 物品名:"粗壮常青树"->正在燃烧
			BURNT = "一夕烬尽。",		-- 物品名:"粗壮常青树"->烧焦的
			CHOPPED = "伐木再歌秋鬓短，停云独立越江偏。",		-- 物品名:"粗壮常青树"->被砍了
			GENERIC = "自小刺头深草里，而今渐觉出蓬蒿。",		-- 物品名:"粗壮常青树"->默认
		},
		-- 常青树掉落				
		PINECONE = "里面藏着生命的周而复始。",		-- 物品名:"松果"
		PINECONE_SAPLING = "未来的参天大树。",		-- 物品名:"常青树苗"
		LUMPY_SAPLING = "它会自己插柳吗？",		-- 物品名:"有疙瘩的树苗"->粗壮常青树树苗
		
		-- 桦栗树
		DECIDUOUSTREE =
		{
			BURNING = "真是浪费。",		-- 物品名:"桦栗树"->正在燃烧
			BURNT = "事已至此，还能如何呢，可惜。",		-- 物品名:"桦栗树"->烧焦的
			CHOPPED = "军行斫桦作晨炊，烟火参差满戍楼。",		-- 物品名:"桦栗树"->被砍了
			POISON = "看来自然做出了反击。",		-- 物品名:"桦栗树"->毒化的
			GENERIC = "惟余白桦知我意，向人犹作去年香。",		-- 物品名:"桦栗树"->默认
		},
		BIRCHNUTDRAKE = "疯狂的小坚果。",		-- 物品名:"桦栗果精"
		ACORN_SAPLING = "它会长大的。",		-- 物品名:"桦栗树树苗"
		ACORN = "比起吃掉它，也许更应该把它埋进土里。",		-- 物品名:"桦栗果"
		ACORN_COOKED = "味道不错。",		-- 物品名:"烤桦栗果"
		-- 尖刺树
		MARSH_TREE =
		{
			BURNING = "像是大漠的胡杨被战火点燃。",		-- 物品名:"针刺树"->正在燃烧
			BURNT = "在这贫瘠的土地长大并不容易，烧毁它却很容易。",		-- 物品名:"针刺树"->烧焦的
			CHOPPED = "砍掉他还得小心尖刺。",		-- 物品名:"针刺树"->被砍了
			GENERIC = "撞上去肯定很痛。",		-- 物品名:"针刺树"->默认
		},
		-- 棕榈松果树
		PALMCONETREE = "碧盖擎炎日，千刃裂长风。",	-- 物品名:"棕榈松果树"
		PALMCONE_SEED = "铁心蕴碧魂，衔春破坚壳。",	-- 物品名:"棕榈松果树芽"
		PALMCONE_SAPLING = "沐风饮炎日，寸寸向云嘶。",	-- 物品名:"棕榈松果树苗"
		PALMCONE_SCALE = "千甲覆龙躯，斑驳刻岁痕。",	-- 物品名:"棕榈松果树鳞片"
		-- 月树
		MOON_TREE =
		{
			BURNING = "吴刚为什么没想到这个方法呢？",		-- 物品名:"月树"->正在燃烧
			BURNT = "它燃尽了。",		-- 物品名:"月树"->烧焦的
			CHOPPED = "似乎吴刚的工作也没那么难？",		-- 物品名:"月树"->被砍了
			GENERIC = "没曾想月亮上还长树。",		-- 物品名:"月树"->默认
		},
		MOON_TREE_BLOSSOM = "树梢飘落的，似是桂花？",		-- 物品名:"月树花"
		MOONBUTTERFLY_SAPLING = "月亮的后裔已经叛离了这个世界。",		-- 物品名:"月树苗"

		LIVINGTREE = "你也只是一颗“树”而已，“伐木工”怎么会在乎树的感受呢？",		-- 物品名:"完全正常的树"
		-- 水中木
		OCEANTREENUT = "巨大的种子。",		-- 物品名:"疙瘩树果"
		OCEANTREE = "看着还可以。",		-- 物品名:"疙瘩树"
		OCEANTREE_PILLAR = "毕竟只是催长的产物。",		-- 物品名:"高出平均值的树干"
		OCEANVINE = "大疙瘩树的藤蔓。",		-- 物品名:"苔藓藤条"
		-- 惊喜种子作物
		ANCIENTTREE_SEED = "神秘的种子，不知道会长出什么？",	--物品名:"惊喜种子"
		ANCIENTTREE_SAPLING_ITEM = "得找片岩石区域把它种下。",	--物品名:"萌芽石苗"
		-- 萌芽石
		ANCIENTTREE_SAPLING = {
			GENERIC = "它在生长。",	--物品名:"年轻萌芽石"->默认
			WRONG_TILE = "它只喜欢岩石。",	--物品名:"年轻萌芽石"->地皮错误
			WRONG_SEASON = "也许这个季节不适合它生长。",	--物品名:"年轻萌芽石"->季节不对
		},
		ANCIENTTREE_GEM = {
			GENERIC = "它在用火焰煅烧着什么。",	--物品名:"萌芽石"->默认
			STUMP = "被挖走了。",	--物品名:"萌芽石"->被开采
		},
		ANCIENTFRUIT_GEM = "足够的温度才能帮它破开种皮。",	--物品名:"晶洞果"

		-- 阴郁之棘
		ANCIENTTREE_NIGHTVISION_SAPLING =
		{
			GENERIC = "它的生长真是缓慢。",-- 年轻阴郁之棘
			WRONG_TILE = "它需要在沼泽地生长。",      -- 地皮错误
			WRONG_SEASON = "它只在凛冬的寒风中生长。",-- 季节不对
		},	
		ANCIENTTREE_NIGHTVISION = {
			GENERIC = "看起来的确很阴郁。",	--物品名:"阴郁之棘"->默认
			STUMP = "一截树桩。",	--物品名:"阴郁之棘"->被开采
		},
		ANCIENTTREE_NIGHTVISION_SAPLING_ITEM = "我得把它种在沼泽地。",-- 阴郁之棘苗(物品形态)
		ANCIENTFRUIT_NIGHTVISION = "像是跳动的心脏？",	--物品名:"夜莓"
		ANCIENTFRUIT_NIGHTVISION_COOKED = "看起来它死掉了。",	--物品名:"熟夜莓"
------ 材料&制作道具(远古制作站、暗影术基站、辉煌锻造台、天体科技单独分类) ------------------------------------------------
	------ 精炼分类
		FLINT = "尖锐的石头，不需要再打磨便可使用。",		-- 物品名:"燧石"
		NITRE = "地火凝霜骨，硝焰裂金石。",		-- 物品名:"硝石"
		TWIGS = "斫取青枝散作柴，敛尽枯荣入襟怀。",		-- 物品名:"树枝"
		CUTGRASS = "也许可以搭一座草庐。",		-- 物品名:"采下的草"
		ROPE = "昼尔于茅,宵尔索陶。",		-- 物品名:"绳子" 制造描述:"紧密编成的草绳，非常有用。"
		-- 木头
		LOG =
		{
			BURNING = "把它丢进火坑燃烧效果会更好。",		-- 物品名:"木头"->正在燃烧
			GENERIC = "建设家园离不开木材。",		-- 物品名:"木头"->默认
		},
		BOARDS = "弹墨拉锯，截以取直。",		-- 物品名:"木板" 制造描述:"更平直的木头。"
		CHARCOAL = "伐薪烧炭南山中。",		-- 物品名:"木炭"
		ROCKS = "小块的石头比大块的更好加工。",		-- 物品名:"石头"
		CUTSTONE = "无规无圆，无矩无方。",		-- 物品名:"石砖" 制造描述:"切成正方形的石头。"

		CUTREEDS = "川原秋色静，芦苇晚风鸣。",		-- 物品名:"采下的芦苇"
		PAPYRUS = "诗不成求膏泽，得一捺占尽山海色，耕钓鱼饮酌。",		-- 物品名:"莎草纸" 制造描述:"用于书写。"
		WAXPAPER = "用纸来包装纸，不错的注意。",		-- 物品名:"蜡纸" 制造描述:"用于打包东西。"

		GOLDNUGGET = "可惜，无论拥有再多的财富，也无法在死后带走。",		-- 物品名:"金块"
		WAGPUNK_BITS = "损坏的机械碎片，也许还有用。",	-- 物品名:"废料"
		TRANSISTOR = "它的用处还很多。",		-- 物品名:"电子元件" 制造描述:"科学至上！滋滋滋！"

		MARBLE = "坚硬，沉重，可靠。",		-- 物品名:"大理石"
		MARBLEBEAN = "它会长出一颗巨大的大理石藤蔓通往天空的巨大啊城堡吗？我觉得不会。",		-- 物品名:"大理石豌豆" 制造描述:"种植一片大理石森林。"
		MARBLEBEAN_SAPLING = "还真是，种豆得豆。",		-- 物品名:"大理石芽"

		ROCK_MOON = "来自星辰。",		-- 物品名:"月岩"
		MOONROCKNUGGET = "来自星辰。",		-- 物品名:"月岩"
		MOONROCKCRATER = "来自月亮的石岩。制成的魔法器皿。",		-- 物品名:"带孔月岩" 制造描述:"用于划定地盘的岩石。"

		REDMOONEYE = "红色的瞳孔。",		-- 物品名:"红色月眼"
		PURPLEMOONEYE = "使用暗影的力量窥伺这片地方，",		-- 物品名:"紫色月眼"
		GREENMOONEYE = "那东西会密切关注这地方。",		-- 物品名:"绿色月眼"
		ORANGEMOONEYE = "橙色宝石有空间的能力，也许可以做到一些特殊的事。",		-- 物品名:"橘色月眼"
		YELLOWMOONEYE = "可惜不会发光。",		-- 物品名:"黄色月眼"
		BLUEMOONEYE = "它应该也能看向月亮。",		-- 物品名:"蓝色月眼"

		ICE = "清光澈骨堪消暑，犹带松风涧底声。",		-- 物品名:"冰"

		NIGHTMAREFUEL = "一种能量残余物，可以给我的灯添加燃料。",		-- 物品名:"噩梦燃料" 制造描述:"傻子和疯子使用的邪恶残渣。"
		LIVINGLOG = "不要恐慌。",		-- 物品名:"活木头" 制造描述:"用你的身体来代替\n你该干的活吧。"

		DREADSTONE = "噩梦凝聚成绝望的固态。",	-- 物品名:"绝望石" 制造描述:"化纯粹恐惧为绝望石。"
		HORRORFUEL = "纯粹的噩梦。",	-- 物品名:"纯粹恐惧" 制造描述:"化绝望石为纯粹恐惧。"

		PUREBRILLIANCE = "纯粹而浓郁的月亮能量。",	-- 物品名:"纯粹辉煌"
		LUNARPLANT_HUSK = "这些花园寄生者的壳也许有用。",	-- 物品名:"亮茄外壳"
		-- 生物材料
		BEARDHAIR = "有点恶心。",		-- 物品名:"胡子"
		MALBATROSS_FEATHERED_WEAVE = "一张美丽的羽毛被。可惜太大了。",		-- 物品名:"羽毛帆布" 制造描述:"精美的羽毛布料。"
		BONESHARD = "敲碎的骨头。",		-- 物品名:"骨头碎片"
		BEESWAX = "有效的防腐手段，或许我的酒可以存储更久？",		-- 物品名:"蜂蜡" 制造描述:"一种有用的防腐蜂蜡。"
		------ 工具分类
		-- 石头工具
		AXE = "伐木丁丁，鸟鸣嘤嘤。",		-- 物品名:"斧头" 制造描述:"砍倒树木！"
		PICKAXE = "挖呀挖呀挖。",		-- 物品名:"鹤嘴锄" 制造描述:"凿碎岩石。"
		PITCHFORK = "这里也没有那么多草垛要堆。",		-- 物品名:"干草叉" 制造描述:"铲地用具。"
		SHOVEL = "在小小的花园里挖呀挖呀挖。",		-- 物品名:"铲子" 制造描述:"挖掘各种各样的东西。"
		FARM_HOE = "躬身戴月归，丰年自此兴。",		-- 物品名:"园艺锄" 制造描述:"翻耕，为撒播农作物做准备。"
		-- 杂项
		HAMMER = "希望没人会去拿我的酒坛玩打西瓜游戏。",		-- 物品名:"锤子" 制造描述:"敲碎各种东西。"
		BUGNET = "抓虫子用的。",		-- 物品名:"捕虫网" 制造描述:"抓虫子用的。"
		RAZOR = "很锋利，年也许会拿它去剪夕的发型。",		-- 物品名:"剃刀" 制造描述:"剃掉你脏脏的山羊胡子。"
		-- 金工具
		GOLDENAXE = "不是所有的金制品都能拿来砍树。",		-- 物品名:"黄金斧头" 制造描述:"砍树也要有格调！"
		GOLDENPICKAXE = "“金”诚所至，“精”石为开。",		-- 物品名:"黄金鹤嘴锄" 制造描述:"像大Boss一样砸碎岩石。"	
		GOLDENPITCHFORK = "有些人想象中的帝王，用黄金锄头和黄金干草叉劳作。",		-- 物品名:"黄金干草叉" 制造描述:"重新布置整个世界。"
		GOLDENSHOVEL = "我等不及要挖洞了。",		-- 物品名:"黄金铲子" 制造描述:"挖掘作用相同，但使用寿命更长。"
		GOLDEN_FARM_HOE = "皇帝的黄金锄头。",		-- 物品名:"黄金园艺锄" 制造描述:"优雅地耕地。"
		-- 照明
		TORCH = "手执微光。",		-- 物品名:"火炬" 制造描述:"可携带的光源。"
		LANTERN = "一种灯具。",		-- 物品名:"提灯" 制造描述:"可加燃料、明亮、便携！"
		-- 暖石
		HEATROCK =
		{
			FROZEN = "不知道用他冰镇酒效果如何。",		-- 物品名:"暖石"->冰冻 制造描述:"储存热能供旅行途中使用。"
			COLD = "也许该戴个手套再摸它。",		-- 物品名:"冻伤"->冷了
			GENERIC = "更高级的手炉，不仅可以暖手也可以消暑。",		-- 物品名:"暖石"->默认 制造描述:"储存热能供旅行途中使用。"
			WARM = "暖暖的，很贴心。",		-- 物品名:"暖石"->温暖 制造描述:"储存热能供旅行途中使用。"
			HOT = "我好像离不开它了，太暖和了。",		-- 物品名:"中暑"->热了
		},
		-- 捕捉形陷阱
		TRAP = "也许得放个诱饵？",		-- 物品名:"陷阱" 制造描述:"捕捉小型生物。"
		BIRDTRAP = "总会有贪心的小鸟落下来。",		-- 物品名:"捕鸟陷阱" 制造描述:"捕捉会飞的动物。"
		-- 捆绑包装
		BUNDLE = "打包后更省空间！",		-- 物品名:"捆绑物资"
		BUNDLEWRAP = "化零为整。",		-- 物品名:"捆绑包装" 制造描述:"打包你的东西的部分和袋子。"
		-- 降温
		FEATHERFAN = "羽扇纶巾笑谈间，强虏灰飞烟灭。",		-- 物品名:"羽毛扇" 制造描述:"超柔软、超大的扇子。"
		MINIFAN = "休息一下，马上回来。",		-- 物品名:"旋转的风扇" 制造描述:"你得跑起来，才能带来风！"
		--乐器
		PANFLUTE = "梦里笙箫奏旧乐。",		-- 物品名:"排箫" 制造描述:"抚慰凶猛野兽的音乐。"
		ONEMANBAND = "均也许会喜欢这种风格的乐器。",		-- 物品名:"独奏乐器" 制造描述:"疯子音乐家也有粉丝。"
		-- 信号
		MINIFLARE = "一支穿云箭，千军万马来相见。",		-- 物品名:"信号弹" 制造描述:"为你信任的朋友照亮前路。"
		MEGAFLARE = "它会来这里的，它不可能看不到。。",	-- 物品名:"敌对信号弹" 制造描述:"为你的敌人点亮一束光。"
		-- 背包
		BACKPACK = "可以携带更多东西了。",		-- 物品名:"背包" 制造描述:"携带更多物品。"
		PIGGYBACK = "小猪包大肚量。",		-- 物品名:"小猪包" 制造描述:"能装许多东西，但会减慢你的速度。"
		ICEPACK = "毛皮背包有保温效果。",		-- 物品名:"保鲜背包" 制造描述:"容量虽小，但能保持东西新鲜。"
		-- 星象探测仪
		ARCHIVE_RESONATOR_ITEM = "能带领我们寻找一些埋藏的秘密。",		-- 物品名:"天体探测仪"->携带物状态 制造描述:"它会出土什么秘密呢？"
		ARCHIVE_RESONATOR = {
			GENERIC = "它似乎在寻找什么。",		-- 物品名:"天体探测仪"->默认
			IDLE = "它的目标已经达成了。",		-- 物品名:"天体探测仪"->没有剩余的天体遗物
		},
		-- 指南针
		COMPASS =
		{
			GENERIC="我面朝哪个方向？",		-- 物品名:"指南针"->默认 制造描述:"指向北方。"
			N = "坤地北。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			S = "乾天南。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			E = "离火东。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			W = "坎水西。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			NE = "震东北。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			SE = "兑东南。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			NW = "艮西北。",		-- 物品名:"指南针" 制造描述:"指向北方。"
			SW = "巽西南。",		-- 物品名:"指南针" 制造描述:"指向北方。"
		},
		-- 训牛相关
		BRUSH = "让你的毛发更加顺滑。",		-- 物品名:"刷子" 制造描述:"减缓皮弗娄牛毛发的生长速度。"
		SADDLEHORN = "卸下鞍具的工具。",		-- 物品名:"鞍角" 制造描述:"把鞍具撬开。"
		SADDLE_BASIC = "鞍可以让我在上面坐稳。",		-- 物品名:"鞍具" 制造描述:"你坐在动物身上。仅仅是理论上。"
		SADDLE_RACE = "鞍辔雕鞍束骏蹄，金羁玉勒控龙媒。",		-- 物品名:"闪亮鞍具" 制造描述:"抵消掉完成目标所花费的时间。或许。"
		SADDLE_WAR = "古来征战几人还。",		-- 物品名:"战争鞍具" 制造描述:"战场首领的王位。"
		-- 杂项工具
		TRIDENT = "弄潮儿。",		-- 物品名:"刺耳三叉戟" 制造描述:"在汹涌波涛中引领潮流吧！"
		STAFF_TORNADO = "大风车吱呀吱哟哟地转。",		-- 物品名:"天气风向标" 制造描述:"把你的敌人吹走。"
		CANE = "精致的手杖。",		-- 物品名:"步行手杖" 制造描述:"泰然自若地快步走。"
		RESKIN_TOOL = "该大扫除了。",		-- 物品名:"清洁扫把" 制造描述:"把装潢的东西清扫的干干净净。"
		COOKBOOK = "我记得幺弟给我我一本，丢哪去了？",		-- 物品名:"烹饪指南" 制造描述:"查看你收集的食谱。"
		-- 杂项消耗品
		SEWING_KIT = "巧手重联亦无瑕，补尽疏残缀岁华。",		-- 物品名:"针线包" 制造描述:"缝补受损的衣物。"
		WAGPUNKBITS_KIT = "能够维修特殊的物品。",	-- 物品名:"自动修理机" 制造描述:"你得心应手的W.A.R.B.I.S.维修工具！"
		WATERBALLOON = "那些巨大蚊子还是有一点用的。",		-- 物品名:"水球" 制造描述:"球体灭火。"
------ 钓鱼用品分类
		TACKLESTATION = "工欲善其事，必先利其器。",		-- 物品名:"钓具容器" 制造描述:"传统的用饵钓鱼。"	
		-- 钓鱼竿
		FISHINGROD = "希望我不会空军。",		-- 物品名:"钓竿" 制造描述:"去钓鱼。为了鱼。"
		OCEANFISHINGROD = "足够结实。",		-- 物品名:"海钓竿" 制造描述:"像职业选手一样钓鱼吧。"
		-- 海钓配件
		OCEANFISHINGBOBBER_NONE = "可以用浮标提高准度。",		-- 物品名:"鱼钩"
		OCEANFISHINGBOBBER_BALL = "略显简陋，但还可以。",		-- 物品名:"木球浮标" 制造描述:"经典设计，初学者和职业钓手两相宜。"
		OCEANFISHINGBOBBER_OVAL = "更轻便，能抛得更远。",		-- 物品名:"硬物浮标" 制造描述:"在经典浮标的基础上融入了时尚设计。"
		OCEANFISHINGBOBBER_CROW = "黑色的羽毛浮标。",		-- 物品名:"黑羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_ROBIN = "红色的羽毛浮标。",		-- 物品名:"红羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_ROBIN_WINTER = "蓝色的羽毛浮标。",		-- 物品名:"蔚蓝羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_CANARY = "金色的羽毛浮标。",		-- 物品名:"黄羽浮标" 制造描述:"深受职业钓手的喜爱。"
		OCEANFISHINGBOBBER_GOOSE = "麋鹿鹅的羽毛浮力很大，是很好的浮标材料。",		-- 物品名:"鹅羽浮标" 制造描述:"高级羽绒浮标。"
		OCEANFISHINGBOBBER_MALBATROSS = "邪天翁的羽毛不会渗水。",		-- 物品名:"邪天翁羽浮标" 制造描述:"高级巨鸟浮标。"
        -- 鱼饵(四种特殊鱼饵在布景-奶奶岛-寄居蟹隐士-瓶罐交易处)
		OCEANFISHINGLURE_SPINNER_RED = "为早起的鱼儿准备的。",		-- 物品名:"日出旋转亮片" 制造描述:"早起的鱼儿有虫吃。"
		OCEANFISHINGLURE_SPINNER_GREEN = "为看夕阳的鱼儿准备的。",		-- 物品名:"黄昏旋转亮片" 制造描述:"低光照环境里效果最好。"
		OCEANFISHINGLURE_SPINNER_BLUE = "为夜猫子鱼儿准备的。",		-- 物品名:"夜间旋转亮片" 制造描述:"适用于夜间垂钓。"
		OCEANFISHINGLURE_SPOON_RED = "金鳞跃日辉，澄波隐杀机。",		-- 物品名:"日出匙型假饵" 制造描述:"早起的鱼儿有虫吃。"
		OCEANFISHINGLURE_SPOON_GREEN = "赤绡裁霞色，曳影诱沉鳞。",		-- 物品名:"黄昏匙型假饵" 制造描述:"在夕阳中继续垂钓。"
		OCEANFISHINGLURE_SPOON_BLUE = "幽芒淬月魄，龙吟惑夜魂。",		-- 物品名:"夜间匙型假饵" 制造描述:"适用于夜间垂钓。"
		-- 其他钓鱼杂项
		POCKET_SCALE = "简单测量鱼的重量。。",		-- 物品名:"弹簧秤" 制造描述:"随时称鱼的重量！"
		TACKLECONTAINER = "钓鱼佬的工具箱。",		-- 物品名:"钓具箱" 制造描述:"整齐收纳你的钓具。"
		SUPERTACKLECONTAINER = "资深钓鱼佬的钓具箱。",		-- 物品名:"超级钓具箱" 制造描述:"更多收纳钓具的空间？我上钩了！"	
		------ 治疗分类
		HEALINGSALVE = "极端情况下将士们会直接用酒。",		-- 物品名:"治疗药膏" 制造描述:"对割伤和擦伤进行消毒杀菌。"
		BANDAGE = "蜂蜜能解毒。",		-- 物品名:"蜂蜜药膏" 制造描述:"愈合小伤口。"
		TILLWEEDSALVE = "化秽愈身，沃土生肌。",		-- 物品名:"犁地草膏" 制造描述:"慢慢去处病痛。"
		HEALINGSALVE_ACID = "比较恶心，但有效中和酸雨。",	--物品名:"黏糊糊的药膏" 制造描述:"杀不死你的东西会让你变得更强大。"
		-- 睡眠
		BEDROLL_STRAW = "就这样吧，先入梦了。",		-- 物品名:"草席卷" 制造描述:"一觉睡到天亮。"
		BEDROLL_FURRY = "一场温暖又舒适的美梦。",		-- 物品名:"毛皮铺盖" 制造描述:"舒适地一觉睡到天亮！"
		-- 复活
		REVIVER = "真诚的“心”，为死去的朋友提供帮助,原理方会很感兴趣。",		-- 物品名:"告密的心" 制造描述:"鬼魂朋友复活了，好可怕。"
		LIFEINJECTOR = "能帮助我恢复一些损失的力量。",		-- 物品名:"强心针" 制造描述:"提高下你那日渐衰退的最大健康值吧。"
	------ 武器分类
		SPEAR = "王于兴师，修我戈矛，与子同仇！",		-- 物品名:"长矛" 制造描述:"使用尖的那一端。"
		HAMBAT = "如果火腿没有烂掉的话，用来打人还挺疼的，就是有点暴殄天物。",		-- 物品名:"火腿棒" 制造描述:"舍不得火腿套不着狼。"
		BATBAT = "难以想象的组合方式。",		-- 物品名:"蝙蝠棒" 制造描述:"所有科技都如此...耗费精神。"
		NIGHTSWORD = "用噩梦斩断噩梦。",		-- 物品名:"暗夜剑" 制造描述:"造成噩梦般的伤害。"
		NIGHTSTICK = "动如雷震！",		-- 物品名:"晨星锤" 制造描述:"用于夜间战斗的晨光。"
		-- 远程武器
		BOOMERANG = "飞去来！",		-- 物品名:"回旋镖" 制造描述:"来自澳洲土著。"
		BLOWDART_PIPE = "明枪易躲，暗箭难防。",		-- 物品名:"吹箭" 制造描述:"向你的敌人喷射利齿。"
		BLOWDART_FIRE = "希望不会烫嘴。",		-- 物品名:"火焰吹箭" 制造描述:"向你的敌人喷火。"
		BLOWDART_SLEEP = "该睡觉了。",		-- 物品名:"催眠吹箭" 制造描述:"催眠你的敌人。"
		BLOWDART_YELLOW = "附加有雷电的力量。",		-- 物品名:"雷电吹箭" 制造描述:"朝你的敌人放闪电。"
		WHIP = "如果想让它的杀伤性更强，就需要绑上碎铁块。",		-- 三尾猫鞭

		GUNPOWDER = "见天。",		-- 物品名:"火药" 制造描述:"一把火药。"
		TRAP_TEETH = "小心脚下。",		-- 物品名:"犬牙陷阱" 制造描述:"弹出来并咬伤任何踩到它的东西。"
		BEEMINE = "踩到它的人要倒霉了。",		-- 物品名:"蜜蜂地雷" 制造描述:"变成武器的蜜蜂。会出什么问题？"
	------ 衣物分类
		-- 防具
		ARMORGRASS = "草木无法保护我。",		-- 物品名:"草甲" 制造描述:"提供少许防护。"
		ARMORMARBLE = "哈，稳如泰山！",		-- 物品名:"大理石甲" 制造描述:"它很重，但能够保护你。"
		ARMORWOOD = "木制铠甲或许不是一个好的选择。",		-- 物品名:"木甲" 制造描述:"为你抵御部分伤害。"
		ARMORDRAGONFLY = "以子之矛攻子之盾，就会产生大爆炸！",		-- 物品名:"鳞甲" 制造描述:"脾气火爆的盔甲。"
		ARMOR_SANITY = "噩梦的化身？或许能抵御伤害。",		-- 物品名:"魂甲" 制造描述:"保护你的躯体，但无法保护你的心智。"
		WAGPUNKHAT = "朋克风格的智能头盔，但似乎不够智能。",	-- 物品名:"W.A.R.B.I.S.头戴齿轮" 制造描述:"看起来聪明，打起来也聪明。"

		FOOTBALLHAT = "有了它，我的头就不会被当木鱼敲了。",		-- 物品名:"橄榄球头盔" 制造描述:"保护你的脑壳。"
		BEEHAT = "养蜂人必备。",		-- 物品名:"养蜂帽" 制造描述:"防止被愤怒的蜜蜂蜇伤。"
		COOKIECUTTERHAT = "或许我有更好的选择。",		-- 物品名:"饼干切割机帽子" 制造描述:"穿着必须犀利。"
		ARMORWAGPUNK = "外置动力甲，但还是很简陋。",	-- 物品名:"W.A.R.B.I.S.盔甲" 制造描述:"开足马力，全速前进！"
		-- 保暖&降温
		-- 保暖帽
		WINTERHAT = "孩子们最喜欢的款式。",		-- 物品名:"冬帽" 制造描述:"保持脑袋温暖。"
		CATCOONHAT = "一顶小巧的帽子，只是可怜了我们的菲林朋友。",		-- 物品名:"猫帽" 制造描述:"适合那些重视温暖甚于朋友的人。"
		BEEFALOHAT = "味道很不好闻，但是能融入牛群。",		-- 物品名:"牛角帽" 制造描述:"成为牛群中的一员！连气味也变得一样。"
		EARMUFFSHAT = "卡特斯的肚皮在温暖我的耳朵。",		-- 物品名:"兔耳罩" 制造描述:"毛茸茸的保暖物品。"
		-- 降温帽
		STRAWHAT = "该下地干活了。",		-- 物品名:"草帽" 制造描述:"帮助你保持清凉干爽。"
		ICEHAT = "冰冰凉凉的，也许我该拿这些冰去冰镇一下酒会更好。",		-- 物品名:"冰帽" 制造描述:"用科学技术合成的冰帽。"
		WATERMELONHAT = "也许我该掏两个洞让我的角也露出来。",		-- 物品名:"西瓜帽" 制造描述:"提神醒脑，但感觉黏黏的。"
		-- 保暖衣
		SWEATERVEST = "格子图案的背心。",		-- 物品名:"犬牙背心" 制造描述:"粗糙，但挺时尚。"
		TRUNKVEST_SUMMER = "一件冲锋衣，质量有待提升。",		-- 物品名:"透气背心" 制造描述:"暖和，但算不上非常暖和。"
		TRUNKVEST_WINTER = "很暖和。",		-- 物品名:"松软背心" 制造描述:"足以抵御冬季暴雪的保暖背心。"
		BEARGERVEST = "让有需要的人来冬眠吧！",		-- 物品名:"熊皮背心" 制造描述:"熊皮背心。"
		-- 降温衣
		HAWAIIANSHIRT = "看起来像是花花公子。",		-- 物品名:"花衬衫" 制造描述:"适合夏日穿着，或在周五便装日穿着。"
		REFLECTIVEVEST = "太阳甩在身后。",		-- 物品名:"清凉夏装" 制造描述:"穿上这件时尚的背心，让你神清气爽。"
		-- 回SAN
		GOGGLESHAT = "装饰性的护目镜，在沙尘暴里没有太大的作用。",		-- 物品名:"时髦的护目镜" 制造描述:"你可以瞪大眼睛看装饰性护目镜。"
		TOPHAT = "想玩玩帽子戏法吗。",		-- 物品名:"高礼帽" 制造描述:"最经典的帽子款式。"
		FLOWERHAT = "味道真好闻。",		-- 物品名:"花环" 制造描述:"放松神经的东西。"
		KELPHAT = "谁会戴这个呢？",		-- 物品名:"海花冠" 制造描述:"让人神经焦虑的东西。"
		-- 雨具
		RAINCOAT = "千丝垂下难侵鬓，一笠擎天自守晴。",		-- 物品名:"雨衣" 制造描述:"让你保持干燥的防水外套。"
		RAINHAT = "任他滂沱侵肩袖，我自安然步雨中。",		-- 物品名:"雨帽" 制造描述:"手感柔软，防雨必备。"
		UMBRELLA = "空山新雨后，天气晚来秋。",		-- 物品名:"雨伞" 制造描述:"遮阳挡雨！"
		GRASS_UMBRELLA = "撑开一季芙蓉面，收尽三月桃花愁。",		-- 物品名:"花伞" 制造描述:"漂亮轻便的保护伞。"
		EYEBRELLAHAT =	"用眼神喝退暴雨。",		-- 物品名:"眼球伞" 制造描述:"面向天空的眼球让你保持干燥。"
		-- 特殊功能
		BUSHHAT = "丛林生存法则。",		-- 物品名:"灌木丛帽" 制造描述:"很好的伪装！"
		FEATHERHAT = "很像某处文明最喜欢的头饰。",		-- 物品名:"羽毛帽" 制造描述:"头上的装饰。"
		MINERHAT = "一顶头灯，可惜石头落在头顶还是很疼。",		-- 物品名:"矿工帽" 制造描述:"用你脑袋上的灯照亮夜晚。"
		MOLEHAT = "借你的“视力”用用。",		-- 物品名:"鼹鼠帽" 制造描述:"为穿戴者提供夜视能力。"
		ARMORSLURPER = "不食人间烟火，只得风餐露宿。",		-- 物品名:"饥饿腰带" 制造描述:"保持肚子不饿。"
		MUSHROOMHAT = "应该让被黍埋进土里的人戴。",		-- 物品名:"蘑菇帽"
		ANTLIONHAT = "揭开大地的神秘面纱。",	-- 物品名:"刮地皮头盔" 制造描述:"通过去除旧地皮来摇出点新花样。"
		DESERTHAT = "平沙莽莽，烽烟惹眼。",		-- 物品名:"沙漠护目镜" 制造描述:"从你的眼睛里把沙子揉出来。"
		MOONSTORM_GOGGLESHAT = "奇妙的构思。",		-- 物品名:"天文护目镜" 制造描述:"利用土豆之眼来看清风暴。"
	------ 建筑分类
		-- 营火(临时火堆)
		CAMPFIRE =
		{
			EMBERS = "火要灭了，必须得加燃料了。",		-- 物品名:"营火"->即将熄灭 制造描述:"燃烧时发出光亮。"
			GENERIC = "一如当年军情紧急的时候，将士们围火无言，真让人怀念。",		-- 物品名:"营火"->默认 制造描述:"燃烧时发出光亮。"
			HIGH = "火势有点大。",		-- 物品名:"营火"->大火 制造描述:"燃烧时发出光亮。"
			LOW = "也许得加点燃料了。",		-- 物品名:"营火"->小火 制造描述:"燃烧时发出光亮。"
			NORMAL = "这种情况下应该正好。",		-- 物品名:"营火"->普通 制造描述:"燃烧时发出光亮。"
			OUT = "薪火燃尽，待月落天明，该上路了。",		-- 物品名:"营火"->灭了 制造描述:"燃烧时发出光亮。"
		},
        -- 吸热营火(临时冷火堆)
		COLDFIRE =
		{
			EMBERS = "火要灭了。",		-- 物品名:"吸热营火"->即将熄灭 制造描述:"这火是越烤越冷的冰火。"
			GENERIC = "它会吸收热量。",		-- 物品名:"吸热营火"->默认 制造描述:"这火是越烤越冷的冰火。"
			HIGH = "火势有点大。",		-- 物品名:"吸热营火"->高 制造描述:"这火是越烤越冷的冰火。"
			LOW = "也许得加点燃料了。",		-- 物品名:"吸热营火"->低？ 制造描述:"这火是越烤越冷的冰火。"
			NORMAL = "这种情况下应该正好。",		-- 物品名:"吸热营火"->普通 制造描述:"这火是越烤越冷的冰火。"
			OUT = "薪火燃尽，待月落天明，该上路了。",		-- 物品名:"吸热营火"->出去？外面？ 制造描述:"这火是越烤越冷的冰火。"
		},
		-- 火坑(石头火堆)
		FIREPIT =
		{
			EMBERS = "在火熄灭之前我得加点燃料。",		-- 物品名:"火坑"->即将熄灭 制造描述:"一种更安全、更高效的营火。"
			GENERIC = "更安全的营火。",		-- 物品名:"火坑"->默认 制造描述:"一种更安全、更高效的营火。"
			HIGH = "它不会肆虐。",		-- 物品名:"火坑"->大火 制造描述:"一种更安全、更高效的营火。"
			LOW = "也许得加点燃料了。",		-- 物品名:"火坑"->小火 制造描述:"一种更安全、更高效的营火。"
			NORMAL = "没有大漠的狂风，没有更夜的急报，只有温暖的火。",		-- 物品名:"火坑"->普通 制造描述:"一种更安全、更高效的营火。"
			OUT = "下次不需要再次堆柴即可再次点燃。",		-- 物品名:"火坑"->灭了 制造描述:"一种更安全、更高效的营火。"
		},
		-- 冷火坑(冰冷石头火堆)
		COLDFIREPIT =
		{
			EMBERS = "在火熄灭之前我得加点燃料。",		-- 物品名:"吸热火坑"->即将熄灭 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			GENERIC = "更安全的吸热营火。",		-- 物品名:"吸热火坑"->默认 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			HIGH = "它不会肆虐。",		-- 物品名:"吸热火坑"->大火 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			LOW = "火变得有点小了。",		-- 物品名:"吸热火坑"->小火 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			NORMAL = "真舒服。",		-- 物品名:"吸热火坑"->普通 制造描述:"燃烧效率更高，但仍然越烤越冷。"
			OUT = "下次不需要再次堆柴即可再次点燃。",		-- 物品名:"吸热火坑"->灭了 制造描述:"燃烧效率更高，但仍然越烤越冷。"
		},
		NIGHTLIGHT = "燃烧恐惧，照亮夜晚。",		-- 物品名:"魂灯" 制造描述:"用你的噩梦点亮夜晚。"
		-- 咩咩雕像
		COTL_TABERNACLE_LEVEL1 =
		{
			LIT = "温馨的小雕塑。",	-- 物品名:"低微咩咩雕像"->燃烧 制造描述:"劣质的咩咩雕刻品。"
			GENERIC = "得加点燃料。",	-- 物品名:"低微咩咩雕像"->默认 制造描述:"劣质的咩咩雕刻品。"
		},
		COTL_TABERNACLE_LEVEL2 =
		{
			LIT = "更加精致了。",	-- 物品名:"有所改进咩咩雕像"->燃烧 制造描述:"一座用来歌颂咩咩的精致雕像。"
			GENERIC = "得加点燃料。",	-- 物品名:"有所改进咩咩雕像"->默认 制造描述:"一座用来歌颂咩咩的精致雕像。"
		},
		COTL_TABERNACLE_LEVEL3 =
		{
			LIT = "别看我只是一只羊，羊儿的聪明难以想象。",	-- 物品名:"完美无瑕咩咩雕像"->燃烧 制造描述:"一座纪念咩咩荣耀的耀眼纪念碑。"
			GENERIC = "得加点燃料。",	-- 物品名:"完美无瑕咩咩雕像"->默认 制造描述:"一座纪念咩咩荣耀的耀眼纪念碑。"
		},

		ROPE_BRIDGE_KIT = "与其绕开，不如架桥。",	--物品名:"洞穴探险者的桥梁套件" 制造描述:"放下你的疑虑，跨过那个无底洞。"
		-- 箱子
		TREASURECHEST =
		{
			GENERIC = "还算坚固的储藏箱。",		-- 物品名:"箱子"->默认 制造描述:"一种结实的容器。"
			BURNT = "木制品易燃。",		-- 物品名:"箱子"->烧焦的 制造描述:"一种结实的容器。"
			UPGRADED_STACKSIZE = "扩容后能储存更多物品。",	-- 物品名:"箱子"->扩容 制造描述:"一种结实的容器。"
		},
		-- 龙鳞宝箱
		DRAGONFLYCHEST =
		{
			GENERIC = "我的酒放在里面就不怕失火了。",	-- 物品名:"龙鳞宝箱"->默认 制造描述:"一种结实且防火的容器。"
			UPGRADED_STACKSIZE = "它的“肚量”更大了。",	-- 物品名:"龙鳞宝箱"->扩容 制造描述:"一种结实且防火的容器。"
		},
		-- 龙鳞火炉
		DRAGONFLYFURNACE =
		{
			HAMMERED = "看起来不太对啊。",		-- 物品名:"龙鳞火炉"->被锤了 制造描述:"给自己建造一个苍蝇暖炉。"
			GENERIC = "很热，但不够亮。", --no gems		-- 物品名:"龙鳞火炉"->默认 制造描述:"给自己建造一个苍蝇暖炉。"
			NORMAL = "室虚窗白炉火暖，闭户幸有图书乐。", --one gem		-- 物品名:"龙鳞火炉"->普通 制造描述:"给自己建造一个苍蝇暖炉。"
			HIGH = "这火力，倒让我想起起了某位暴脾气的天师。", --two gems		-- 物品名:"龙鳞火炉"->猛火 制造描述:"给自己建造一个苍蝇暖炉。"
		},
		--  石桌
		STONE_TABLE = 
		{
			GENERIC = "无物扰心绪，有空待月明。",	--物品名:"圆石桌/方石桌"->没东西 制造描述:"圆形石桌，用来放东西。/方形石桌，用来放东西。"
			HAS_ITEM = "石案承千钧，纳尽世间尘。",	--物品名:"圆石桌/方石桌"->有东西 制造描述:"圆形石桌，用来放东西。/方形石桌，用来放东西。"
		},
		--  石椅
		STONE_CHAIR =
		{
			GENERIC = "空庭寂无语，惟待故人裳。",	--物品名:"石椅"->无人 制造描述:"可以坐的石椅。"
			OCCUPIED = "俯仰阅尘世，无言伴流年。",	--物品名:"石椅"->有人 制造描述:"可以坐的石椅。"
		},
		-- 茶几
		ENDTABLE =
		{
			BURNT = "繁花，不敌烈火焚天。",		-- 物品名:"茶几"->烧焦的 制造描述:"一张装饰桌。"
			GENERIC = "花开堪折直须折。",		-- 物品名:"茶几"->有花 制造描述:"一张装饰桌。"
			EMPTY = "也许该在里面插一枝花，而不是装一壶酒。",		-- 物品名:"茶几"->空的 制造描述:"一张装饰桌。"
			WILTED = "花谢花开花漫天。",		-- 物品名:"茶几"->花枯萎了 制造描述:"一张装饰桌。"
			FRESHLIGHT = "此时此景，不饮一杯，岂不是愧对自己？",		-- 物品名:"茶几"->有新鲜荧光果 制造描述:"一张装饰桌。"
			OLDLIGHT = "需要更换新的荧光果了。",	-- will be wilted soon, light radius will be very small at this point	-- 物品名:"茶几"->荧光果不新鲜 制造描述:"一张装饰桌。"
		},

		-- 避雷针
		LIGHTNING_ROD =
		{
			CHARGED = "雷霆破翳，前路昭明！",		-- 物品名:"避雷针"->充能 制造描述:"防雷劈。"
			GENERIC = "避雷针不避雷，而是引雷。",		-- 物品名:"避雷针"->默认 制造描述:"防雷劈。"
		},
		-- 木牌
		HOMESIGN =
		{
			GENERIC = "在~这~里~呦~”。",		-- 物品名:"路牌"->默认 制造描述:"在世界中留下你的标记。"
			UNWRITTEN = "该题一句什么呢？",		-- 物品名:"路牌"->没有写字 制造描述:"在世界中留下你的标记。"
			BURNT = "也许该在上面写--严禁烟火。",		-- 物品名:"路牌"->烧焦的 制造描述:"在世界中留下你的标记。"
		},
		-- 小木牌
		MINISIGN_ITEM = "找一处摹形的地方。",		-- 物品名:"小木牌" 制造描述:"用羽毛笔在这些上面画画。"
		MINISIGN =
		{
			GENERIC = "还不赖。",		-- 物品名:"小木牌"->画上了东西
			UNDRAWN = "夕最擅长这个。",		-- 物品名:"小木牌"->没有画
		},
		-- 指路木牌
		ARROWSIGN_POST =
		{
			GENERIC = "它说“那个方向”。",		-- 物品名:"指路标志"->默认 制造描述:"对这个世界指指点点。或许只是打下手势。"
			UNWRITTEN = "“仙人指路”",		-- 物品名:"指路标志"->没有写字 制造描述:"对这个世界指指点点。或许只是打下手势。"
			BURNT = "小心火烛。",		-- 物品名:"指路标志"->烧焦的 制造描述:"对这个世界指指点点。或许只是打下手势。"
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "应该是这边？吧？",		-- 物品名:"指路标志"->默认
			UNWRITTEN = "一片空白。",		-- 物品名:"指路标志"->没有写字
			BURNT = "小心火烛。",		-- 物品名:"指路标志"->烧焦的
		},
		-- 鸟笼
		BIRDCAGE =
		{
			GENERIC = "谁会想成为笼中物呢？",		-- 物品名:"鸟笼"->空的 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			OCCUPIED = "可怜飞燕倚新妆。",		-- 物品名:"鸟笼"->有鸟 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			SLEEPING = "在梦里它会得到自由。",		-- 物品名:"鸟笼"->睡着了 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			HUNGRY = "它看起来有点饿。",		-- 物品名:"鸟笼"->有点饿了 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			STARVING = "诶呦，得赶紧喂它点吃的。",		-- 物品名:"鸟笼"->挨饿 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			DEAD = "至少，鸟笼再也困不住它的精神了。",		-- 物品名:"鸟笼"->死了 制造描述:"为你的鸟类朋友提供一个幸福的家。"
			SKELETON = "希望它能安息。",		-- 物品名:"鸟笼"->骷髅
		},
		-- 鸟笼产物
		GUANO = "来自天空的“农家肥”。",		-- 物品名:"鸟粪"
		BIRD_EGG = "小小的鸟蛋。",		-- 物品名:"鸟蛋"
		BIRD_EGG_COOKED = "还可以。",		-- 物品名:"煎蛋"
		ROTTENEGG = "已经变质了。",		-- 物品名:"腐烂鸟蛋"
		-- 食材保鲜
		ICEBOX = "我更想在里面塞满酒坛。",		-- 物品名:"冰箱" 制造描述:"延缓食物变质。"
		SALTBOX = "古法存储食物。",		-- 物品名:"盐盒" 制造描述:"用盐来储存食物。"
		-- 烹饪锅
		COOKPOT =
		{
			EMPTY = "看着都觉得饿。",		-- 物品名:"烹饪锅"->空的 
			COOKING_LONG = "这还需要一点时间。",		-- 物品名:"烹饪锅"->饭还需要很久
			COOKING_SHORT = "就快好了！",		-- 物品名:"烹饪锅"->饭快做好了
			DONE = "嗯！可以吃了！",		-- 物品名:"烹饪锅"->完成了
			BURNT = "厨艺堪比芙蓉小姐了。",		-- 物品名:"烹饪锅"->烧焦的
		},
		-- 灭火器
		FIRESUPPRESSOR =
		{
			ON = "它会自动灭火与灌溉。",		-- 物品名:"雪球发射器"->开启 制造描述:"拯救植物，扑灭火焰，可添加燃料。"
			OFF = "一切都平息了。",		-- 物品名:"雪球发射器"->关闭 制造描述:"拯救植物，扑灭火焰，可添加燃料。"
			LOWFUEL = "也许得加点燃料了。",		-- 物品名:"雪球发射器"->燃料不足 制造描述:"拯救植物，扑灭火焰，可添加燃料。"
		},
		-- 科学机器
		RESEARCHLAB =
		{
			GENERIC = "在它旁边我可以研究更多东西了。",		-- 物品名:"科学机器"->默认 制造描述:"解锁新的合成配方！"
			BURNT = "凭栏望火，不知其热。直至眼下。",		-- 物品名:"科学机器"->烧焦的 制造描述:"解锁新的合成配方！"
		},
		-- 炼金引擎
		RESEARCHLAB2 =
		{
			GENERIC = "先进的炼金引擎完全超越了老旧的科学机器。",		-- 物品名:"炼金引擎"->默认 制造描述:"解锁更多合成配方！"
			BURNT = "更先进的材料也还是抵挡不住烈火。",		-- 物品名:"炼金引擎"->烧焦的 制造描述:"解锁更多合成配方！"
		},
		-- 暗影操控仪
		RESEARCHLAB3 =
		{
			GENERIC = "以暗影操纵暗影。",		-- 物品名:"暗影操控器"->默认 制造描述:"这还是科学吗？"
			BURNT = "不管它原来是什么，现在已经烧掉了。",		-- 物品名:"暗影操控器"->烧焦的 制造描述:"这还是科学吗？"
		},
		-- 灵子分解器
		RESEARCHLAB4 =
		{
			GENERIC = "你要表演魔术吗？",		-- 物品名:"灵子分解器"->默认 制造描述:"增强高礼帽的魔力。"
			BURNT = "看来你没有灭火的戏法。",		-- 物品名:"灵子分解器"->烧焦的 制造描述:"增强高礼帽的魔力。"
		},
		-- 肉块雕像
		RESURRECTIONSTATUE =
		{
			GENERIC = "一昧的逃避没有意义，无论逃得多远，我们终归还是要面对祂。",		-- 物品名:"肉块雕像"->默认 制造描述:"以肉的力量让你重生。"
			BURNT = "看来一条“退路”被烧毁了。",		-- 物品名:"肉块雕像"->烧焦的 制造描述:"以肉的力量让你重生。"
		},
		-- 废料墙
		WALL_SCRAP = "废土风格。",	-- 物品名:"废料墙"
		WALL_SCRAP_ITEM = "一些无用的东西。",	-- 物品名:"废料墙"->携带物状态
		-- 草墙
		WALL_HAY =
		{
			GENERIC = "这下真就是“草庐”了。",		-- 物品名:"草墙"->默认
			BURNT = "集中在一起烧得更快了。",		-- 物品名:"草墙"->烧焦的
		},
		WALL_HAY_ITEM = "只能应付着用了。",		-- 物品名:"草墙"->携带物状态 制造描述:"草墙墙体。不太结实。"
		-- 木墙
		WALL_WOOD =
		{
			GENERIC = "上面的尖刺能挡住一些东西。",		-- 物品名:"木墙"->默认
			BURNT = "一霎焚风吞万物，空余黢木泣残阳。",		-- 物品名:"木墙"->烧焦的
		},
		WALL_WOOD_ITEM = "小心尖刺。",		-- 物品名:"木墙"->携带物状态 制造描述:"木墙墙体。"
		-- 石墙
		WALL_STONE = "看起来足够坚硬。",		-- 物品名:"石墙"
		WALL_STONE_ITEM = "石头砌墙可追溯到茹毛饮血的远古时代，那时候我们都是祂。",		-- 物品名:"石墙"->携带物状态 制造描述:"石墙墙体。"
		-- 铥墙
		WALL_RUINS = "苔痕漫染前朝事，一墙隔断世炎凉。",		-- 物品名:"铥矿墙"
		WALL_RUINS_ITEM = "活着的历史。",		-- 物品名:"铥矿墙"->携带物状态 制造描述:"这些墙可以承受相当多的打击。"
		-- 月岩墙
		WALL_MOONROCK = "桂影不随尘世改，万古清冷护乾坤。",		-- 物品名:"月岩墙"
		WALL_MOONROCK_ITEM = "轻盈且坚硬。",		-- 物品名:"月岩墙"->携带物状态 制造描述:"月球疯子之墙。"
		
		-- 衣柜
		WARDROBE =
		{
			GENERIC = "千面万面，不都是我吗？",		-- 物品名:"衣柜"->默认 制造描述:"随心变换面容。"
			BURNING = "这里面的衣物可不便宜。",		-- 物品名:"衣柜"->正在燃烧 制造描述:"随心变换面容。"
			BURNT = "付之一炬。",		-- 物品名:"衣柜"->烧焦的 制造描述:"随心变换面容。"
		},
		-- 温度计
		WINTEROMETER =
		{
			GENERIC = "寸心知寒暑，赤汞诉炎凉。",		-- 物品名:"温度测量仪"->默认 制造描述:"测量环境气温。"
			BURNT = "看来它热炸了。",		-- 物品名:"温度测量仪"->烧焦的 制造描述:"测量环境气温。"
		},
		-- 雨量计
		RAINOMETER =
		{
			GENERIC = "圆罂测雨。",		-- 物品名:"雨量计"->默认 制造描述:"观测降雨机率。"
			BURNT = "承接雨露，却无力自救。",		-- 物品名:"雨量计"->烧焦的 制造描述:"观测降雨机率。"
		},
		-- 帐篷
		TENT =
		{
			GENERIC = "更温暖的帐篷，做个更美的梦。",		-- 物品名:"帐篷"->默认 制造描述:"回复理智值，但要花费时间并导致饥饿。"
			BURNT = "看来今晚只能打地铺了。",		-- 物品名:"帐篷"->烧焦的 制造描述:"回复理智值，但要花费时间并导致饥饿。"
		},
		-- 遮阳棚
		SIESTAHUT =
		{
			GENERIC = "在没有太阳的地方，做场白日梦。",		-- 物品名:"遮阳篷"->默认 制造描述:"躲避烈日，回复理智值。"
			BURNT = "太阳以另一种形式摧毁的它。",		-- 物品名:"遮阳篷"->烧焦的 制造描述:"躲避烈日，回复理智值。"
		},
		-- 普通拳击袋
		PUNCHINGBAG = 
		{
			"形不成…你们解…劲发…千招百…你们…形…劲发江潮…",
			"你们…千招百…解决问题…形不…还是…劲发…成形…",
			"茎花姜炒螺，骑手求好评。",
			"先找博士再一息。",
		},
		-- 明亮拳击袋
		PUNCHINGBAG_LUNAR = 
		{
			"请指教。",
			"别动，你现在被捕了，你有权保持沉默。",
			"有些事你理解不了，有些东西千金不换。",
			"投降吧，外面都是警察。",
		},
		-- 暗影拳击袋
		PUNCHINGBAG_SHADOW = 
		{
			"形不成形，意不在意，再去练练吧。",
			"千招百式在一息！",
			"劲发江潮落，气收秋毫平！",
			"你们解决问题，还是只会仰仗干戈吗？",
		}, 
		-- 友善的稻草人
		SCARECROW =
   		{
			GENERIC = "为什么乌鸦会讨厌你呢？",		-- 物品名:"友善的稻草人"->默认 制造描述:"模仿最新的秋季时尚。"
			BURNING = "他应该不会自己引火上身。",		-- 物品名:"友善的稻草人"->正在燃烧 制造描述:"模仿最新的秋季时尚。"
			BURNT = "变成“熟人”了。",		-- 物品名:"友善的稻草人"->烧焦的 制造描述:"模仿最新的秋季时尚。"
   		},
        -- 陶轮
		SCULPTINGTABLE=
   		{
			EMPTY = "让石头转起来。",		-- 物品名:"陶轮" 制造描述:"大理石在你手里将像黏土一样！"
			BLOCK = "要做什么呢？",		-- 物品名:"陶轮"->锁住了 制造描述:"大理石在你手里将像黏土一样！"
			SCULPTURE = "大功告成。",		-- 物品名:"陶轮"->雕像做好了 制造描述:"大理石在你手里将像黏土一样！"
			BURNT = "烧制陶瓷不应该是在这里。",		-- 物品名:"陶轮"->烧焦的 制造描述:"大理石在你手里将像黏土一样！"
   		},
		-- 制图桌
		CARTOGRAPHYDESK =
		{
			GENERIC = "四海八荒，尽收眼底。",		-- 物品名:"制图桌"->默认 制造描述:"准确地告诉别人你去过哪里。"
			BURNING = "火焰在吞噬它。",		-- 物品名:"制图桌"->正在燃烧 制造描述:"准确地告诉别人你去过哪里。"
			BURNT = "只余灰烬。",		-- 物品名:"制图桌"->烧焦的 制造描述:"准确地告诉别人你去过哪里。"
		},
        -- 蜂箱
		BEEBOX =
		{
			READY = "正午云桥疏雨过，冬青花上蜜蜂归。",		-- 物品名:"蜂箱"->有很多蜂蜜 制造描述:"贮存你自己的蜜蜂。"
			FULLHONEY = "蜂不禁人采蜜忙，荷花蕊里作蜂房。",		-- 物品名:"蜂箱"->蜂蜜满了 制造描述:"贮存你自己的蜜蜂。"
			GENERIC = "钱郎嗜读书，巧若蜂采蜜。",		-- 物品名:"蜂箱"->默认 制造描述:"贮存你自己的蜜蜂。"
			NOHONEY = "需要耐心等待了。",		-- 物品名:"蜂箱"->没有蜂蜜 制造描述:"贮存你自己的蜜蜂。"
			SOMEHONEY = "还不是时候。",		-- 物品名:"蜂箱"->有一些蜂蜜 制造描述:"贮存你自己的蜜蜂。"
			BURNT = "可惜了，唉。",		-- 物品名:"蜂箱"->烧焦的 制造描述:"贮存你自己的蜜蜂。"
		},
		-- 蘑菇农场
		MUSHROOM_FARM =
		{
			STUFFED = "该收获了！",		-- 物品名:"蘑菇农场"->长满了 制造描述:"种蘑菇。"
			LOTS = "它还会长的更多。",		-- 物品名:"蘑菇农场"->很多 制造描述:"种蘑菇。"
			SOME = "耐心等待。",		-- 物品名:"蘑菇农场"->有一些 制造描述:"种蘑菇。"
			EMPTY = "它可以使用一个孢子。或是一个蘑菇移植植物。",		-- 物品名:"蘑菇农场"->没有 制造描述:"种蘑菇。"
			ROTTEN = "死去的木头无法提供蘑菇所需的营养。",		-- 物品名:"蘑菇农场"->枯萎--需要活木 制造描述:"种蘑菇。"
			BURNT = "烈火无情，兵戈亦然。。",		-- 物品名:"蘑菇农场"->烧焦的 制造描述:"种蘑菇。"
			SNOWCOVERED = "岁暮阴阳催短景，天涯霜雪霁寒宵。等春天了在试试吧。",		-- 物品名:"蘑菇农场"->被雪覆盖 制造描述:"种蘑菇。"
		},
		-- 晾肉架
		MEATRACK =
		{
			DONE = "可以了。",		-- 物品名:"晾肉架"->完成了 制造描述:"晾肉的架子。"
			DRYING = "让它慢慢风干吧。",		-- 物品名:"晾肉架"->正在风干 制造描述:"晾肉的架子。"
			DRYINGINRAIN = "雨水会把肉打湿。",		-- 物品名:"晾肉架"->雨天风干 制造描述:"晾肉的架子。"
			GENERIC = "也许除了肉还能把其他东西挂上去。",		-- 物品名:"晾肉架"->默认 制造描述:"晾肉的架子。"
			BURNT = "看来它变成一次性熏肉架了。",		-- 物品名:"晾肉架"->烧焦的 制造描述:"晾肉的架子。"
			-- 非肉类物品
			DONE_NOTMEAT = "可惜没有葡萄，不然能制作大漠风味食品。",		-- 物品名:"晾肉架"->完成了非肉 制造描述:"晾肉的架子。"
			DRYING_NOTMEAT = "有效果。",		-- 物品名:"晾肉架"->正在风干非肉 制造描述:"晾肉的架子。"
			DRYINGINRAIN_NOTMEAT = "等雨停了再把它挂上去比较好。",		-- 物品名:"晾肉架"->雨天风干非肉 制造描述:"晾肉的架子。"
		},
		SALTLICK = "用于补充矿物质。",		-- 物品名:"舔盐块"
		SALTLICK_IMPROVED = "为丰蹄朋友补充盐分。",	--物品名:"美味舔盐块" 制造描述:"让您皮弗娄牛品尝到更精致的美食。"
       	-- 月晷
		MOONDIAL =
		{
			GENERIC = "月有阴晴圆缺，人有悲欢离合。",		-- 物品名:"月晷"->默认 制造描述:"追踪月相！"
			NIGHT_NEW = "朔日隐月痕，虚室纳天光。",		-- 物品名:"月晷"->新月 制造描述:"追踪月相！"
			NIGHT_WAX = "上弦挂金钩，西天引宵汉。",		-- 物品名:"月晷"->上弦月 制造描述:"追踪月相！"
			NIGHT_FULL = "望夜悬玉盘，清辉照九州。",		-- 物品名:"月晷"->满月 制造描述:"追踪月相！"
			NIGHT_WANE = "下弦垂银弓，晓窗送夜寒。",		-- 物品名:"月晷"->下弦月 制造描述:"追踪月相！"
			CAVE = "井底之蛙仍有方寸天穹，这里可什么都看不到。",		-- 物品名:"月晷"->洞穴 制造描述:"追踪月相！"
			GLASSED = "想必除了夕娥，月亮上还有其他存在，现在正在看着我？",		-- 物品名:"月晷"->月亮风暴 制造描述:"追踪月相！"
		},
		-- 支柱
		SUPPORT_PILLAR_SCAFFOLD = "用石头支撑并加固洞穴穹顶。",	-- 物品名:"支柱脚手架" 制造描述:"我们都需要一些支持。"
		SUPPORT_PILLAR = "持续的地震让它变得脆弱。",	-- 物品名:"支柱"
		SUPPORT_PILLAR_COMPLETE = "稳定的石柱。",	-- 物品名:"加固支柱"
		SUPPORT_PILLAR_BROKEN = "他失去了作用。",	-- 物品名:"支柱瓦砾"
        -- 沙之石
		TOWNPORTALTALISMAN =
		{
			GENERIC = "将人化为沙子并在远处重聚，在某处海洋好像见过类似的设计。",		-- 物品名:"沙之石"->默认
			ACTIVE = "我该考虑它的安全性吗？不管了，就当大梦一场了。",		-- 物品名:"沙之石"->激活了
		},
	    -- 懒人传送塔
		TOWNPORTAL =
		{
			GENERIC = "很像一些老天师的手艺，但是原理完全不同。",		-- 物品名:"强征传送塔"->默认 制造描述:"用沙子的力量聚集你的朋友们。"
			ACTIVE = "归去来。",		-- 物品名:"强征传送塔"->激活了 制造描述:"用沙子的力量聚集你的朋友们。"
		},

		TURFCRAFTINGSTATION = "来自远古的科技。",		-- 物品名:"土地夯实器" 制造描述:"一点点的改变世界。"
	------ 耕种分类
		-- 堆肥桶	
		COMPOSTINGBIN =
		{
			GENERIC = "能对肥料进行发酵。味道真的很重。",		-- 物品名:"堆肥桶"->默认 制造描述:"能让土壤变得臭烘烘和肥沃。"
			WET = "比例有些不对，太过于潮湿。",		-- 物品名:"堆肥桶"->太湿 制造描述:"能让土壤变得臭烘烘和肥沃。"
			DRY = "比例有些不对，太过于干燥。",		-- 物品名:"堆肥桶"->太干 制造描述:"能让土壤变得臭烘烘和肥沃。"
			BALANCED = "比例正好。",		-- 物品名:"堆肥桶"->湿度合适 制造描述:"能让土壤变得臭烘烘和肥沃。"
			BURNT = "还能更糟吗…",		-- 物品名:"堆肥桶"->烧焦的 制造描述:"能让土壤变得臭烘烘和肥沃。"
		},
		COMPOST = "品质不错的肥料。",		-- 物品名:"堆肥"
		
		FERTILIZER = "也许这不是储存它的最好办法，但眼下没有别的选择了。",		-- 物品名:"便便桶" 制造描述:"少拉点在手上，多拉点在庄稼上。"
		-- 催长剂起子
		SOIL_AMENDER =
		{
			GENERIC = "海带中有很多营养。",		-- 物品名:"催长剂起子"->默认 制造描述:"海里来的瓶装养分。"
			STALE = "有效果了。",		-- 物品名:"催长剂起子"->过期了 制造描述:"海里来的瓶装养分。"
			SPOILED = "还有进一步提升的空间。",		-- 物品名:"催长剂起子"->腐烂了 制造描述:"海里来的瓶装养分。"
		},
		SOIL_AMENDER_FERMENTED = "看来它彻底发酵完毕了。",		-- 物品名:"超级催长剂"
		-- 浇水壶
		WATERINGCAN =
		{
			GENERIC = "水是生命之源。",		-- 物品名:"空浇水壶"->默认 制造描述:"让植物保持快乐和水分。"
			EMPTY = "没有水了，得灌点水。",		-- 物品名:"空浇水壶"->空了 制造描述:"让植物保持快乐和水分。"
		},
		-- 鸟嘴壶
		PREMIUMWATERINGCAN =
		{
			GENERIC = "很棒的水壶。",		-- 物品名:"空鸟嘴壶"->默认 制造描述:"灌溉方面的创新!"
			EMPTY = "没有水就没用了。",		-- 物品名:"空鸟嘴壶"->空了 制造描述:"灌溉方面的创新!"
		},

		FARM_PLOW = "铧犁破土深，黑浪翻泥香。",		-- 物品名:"耕地机"
		FARM_PLOW_ITEM = "得开垦一片新的土地。",		-- 物品名:"耕地机"->携带物状态
		PLANTREGISTRYHAT = "让植物自己告诉我秘密。",		-- 物品名:"耕作先驱帽" 
		-- 农产品秤
		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "看看今秋的收获如何。",		-- 物品名:"农产品秤"->默认 制造描述:"称量你珍贵的水果和蔬菜。"
			HAS_ITEM = "重量: {weight}\n收获日: {day}\n不赖。",		-- 物品名:"农产品秤"->称普通巨型作物 制造描述:"称量你珍贵的水果和蔬菜。"
			HAS_ITEM_HEAVY = "重量: {weight}\n收获日: {day}\n谁能想到会长这么大？",		-- 物品名:"农产品秤"->称重型普通巨型作物 制造描述:"称量你珍贵的水果和蔬菜。"
			HAS_ITEM_LIGHT = "太弱小了，没有力量。",		-- 物品名:"农产品秤"->称非巨型作物 制造描述:"称量你珍贵的水果和蔬菜。"
			BURNING = "这不是烧菜的地方。",		-- 物品名:"农产品秤"->正在燃烧 制造描述:"称量你珍贵的水果和蔬菜。"
			BURNT = "这也不是锅灶啊。",		-- 物品名:"农产品秤"->烧焦的 制造描述:"称量你珍贵的水果和蔬菜。"
		},
		VEGGIE_OVERSIZED_ROTTEN = "攀比的舞台。",		-- 物品名:农产品秤
		SEEDPOUCH = "专门为储存种子设计的袋子。",		-- 物品名:"种子袋" 制造描述:"妥善保管好种子。"
	------ 航海分类
		-- 智囊团
		SEAFARING_PROTOTYPER =
		{
			GENERIC = "感谢你的“参考”。",		-- 物品名:"智囊团"->默认 制造描述:"海上科学。"
			BURNT = "千帆烬。",		-- 物品名:"智囊团"->烧焦的 制造描述:"海上科学。"
		},
		OAR = "剡木匀波循旧例，泗水回纹终归缓。",		-- 物品名:"桨" 制造描述:"划，划，划小船。"
		OAR_DRIFTWOOD = "劈浪分潮试新痕，钱塘一线竟能疾。",		-- 物品名:"浮木桨" 制造描述:"小桨要用浮木造？"
		BOATPATCH = "有备无患。",		-- 物品名:"船补丁" 制造描述:"打补丁永远不晚。"
		BOATPATCH_KELP = "临时用用。",	--物品名:"海带补丁"
		TREEGROWTHSOLUTION = "高效的树木催长剂。",		-- 物品名:"树果酱" 制造描述:"鼓励树木到达新的高度。"
		BOAT_LEAK = "要补漏，不然会沉。",		-- 物品名:"漏洞"
		-- 草筏
		BOAT_GRASS = "权宜之计。",     -- 草筏
		BOAT_GRASS_ITEM = "临时用用还可以。",	-- 物品名:"草筏套装" 制造描述:"享受周末出游的乐趣吧。"
		WALKINGPLANK_GRASS = "我们就不能造一艘救生船吗？",	-- 物品名:"木板"->跳草船用的板子
		-- 木船
		BOAT = "是时候征服海洋了。",  -- 木船
		BOAT_ITEM = "一艘船。",		-- 物品名:"船套装" 制造描述:"让大海成为你的领地。"
		WALKINGPLANK = "我们就不能造一艘救生船吗？",		-- 物品名:"木板"->跳木船用的板子
		-- 甲板照明灯
		MASTUPGRADE_LAMP = "得用火魔杖才能添加燃料。",-- 甲板照明灯(安装)
		MASTUPGRADE_LAMP_ITEM = "我有的是闪闪发光的好主意。",		 -- 甲板照明灯(物品)
		-- 避雷导线
        MASTUPGRADE_LIGHTNINGROD = "让雷暴无能狂怒。",     -- 避雷导线(安装)
		MASTUPGRADE_LIGHTNINGROD_ITEM = "驾驭海上的电力！",	-- 避雷导线(物品)
		WATERPUMP = "有效的借助海水灭火。",		-- 物品名:"消防泵" 制造描述:"水水水，到处都是水！"
		-- 方向舵
		STEERINGWHEEL = "也许得让更专业的人来。",		-- 物品名:"方向舵"
		STEERINGWHEEL_ITEM = "至少有了方向。",		-- 物品名:"方向舵套装" 
		-- 锚
		ANCHOR = "锚定。",		-- 物品名:"锚" 
		ANCHOR_ITEM = "可以停泊了。",		-- 物品名:"锚套装" 制造描述:"船用刹车"
		-- 桅杆
		MAST = "屏徐御风，一夜千里。",		-- 物品名:"桅杆" 制造描述:"乘风破浪会有时。"
		MAST_ITEM = "或许我该再做一个帆？",		-- 物品名:"桅杆套装" 制造描述:"乘风破浪会有时。"
		-- 飞翼风帆
		MAST_MALBATROSS_ITEM = "海阔凭鱼跃，天高任鸟飞。",		-- 物品名:"飞翼风帆套装" 制造描述:"像海鸟一样航向深蓝。"
		MAST_MALBATROSS = "扬帆远航，抵不过彷徨。",		-- 物品名:"飞翼风帆" 制造描述:"像海鸟一样航向深蓝。"
		-- 转向舵
		BOAT_ROTATOR = "方向由我自己掌握。",	-- 物品名:"转向舵"
		BOAT_ROTATOR_KIT = "把控方向。",	-- 物品名:"转向舵套装"

		BOAT_BUMPER_KELP = "稍微有一点用。",	-- 物品名:"海带保险杠"
		BOAT_BUMPER_KELP_KIT = "海带做的保险杠。",	-- 物品名:"海带保险杠套装"
		-- 贝壳保险杠
		BOAT_BUMPER_SHELL = "效果还不错。",	-- 物品名:"贝壳保险杠"
		BOAT_BUMPER_SHELL_KIT = "贝壳做的保险杠。",	-- 物品名:"贝壳保险杠套装"
		-- 夹夹绞盘
		WINCH =
		{
			GENERIC = "可以打捞水下的东西。",		-- 物品名:"夹夹绞盘"->默认 制造描述:"让它帮你捞起重的东西吧。"
			RETRIEVING_ITEM = "会是什么呢？",		-- 物品名:"夹夹绞盘"->正在打捞 制造描述:"让它帮你捞起重的东西吧。"
			HOLDING_ITEM = "费了老大劲。",		-- 物品名:"夹夹绞盘"->捞上来东西了 制造描述:"让它帮你捞起重的东西吧。"
		},
        -- 大炮
		BOAT_CANNON = {
			GENERIC = "腹内乾坤净，喉间日月藏。",	-- 物品名:"大炮"->默认
			AMMOLOADED = "丹膛纳风雷，铁吻噙震怒。",	-- 物品名:"大炮"->已装填
			NOAMMO = "得做点什么装进去。",	-- 物品名:"大炮"->没有弹药
		},
		BOAT_CANNON_KIT = "铁躯铸龙吟，寂然指苍穹。",	-- 物品名:"大炮套装"
		CANNONBALL_ROCK_ITEM = "实心的。",	-- 物品名:"炮弹"
		-- 海洋拖网捕鱼器
		OCEAN_TRAWLER = {
			GENERIC = "千尺纶纲静，只候鱼龙过。",	-- 物品名:"海洋拖网捕鱼器"->默认
			LOWERED = "千鳞未入彀，乾坤已在囊。",	-- 物品名:"海洋拖网捕鱼器"->已下网
			CAUGHT = "绞车收海沸，丰年获满舱。",	-- 物品名:"海洋拖网捕鱼器"->捉到鱼了
			ESCAPED = "忍看千斛珠，还归碧浪深。",	-- 物品名:"海洋拖网捕鱼器"->鱼太多把网撑破了
			FIXED = "断纶续明月，补天终有术。",	-- 物品名:"海洋拖网捕鱼器"->重新修好了
		},
		OCEAN_TRAWLER_KIT = "大海里有的是鱼。",	-- 物品名:"海洋拖网捕鱼器套装"
		-- 自动航行仪
		BOAT_MAGNET =
		{
			GENERIC = "它似乎需要配对其他东西。",	-- 物品名:"自动航行"->默认
			ACTIVATED = "奏效了。",	-- 物品名:"自动航行"->已激活
		},
		BOAT_MAGNET_KIT = "铁索连环，但是靠的不会特别近。",	-- 物品名:"自动航行套装"
		-- 自动航行灯塔
		BOAT_MAGNET_BEACON =
		{
			GENERIC = "它会吸引强力磁铁。",	-- 物品名:"自动航行灯塔"->默认
			ACTIVATED = "磁力！",	-- 物品名:"自动航行灯塔"->已激活
		},
		-- 码头桩
		DOCK_KIT = "让船只靠岸。",	-- 物品名:"码头套装"
		DOCK_WOODPOSTS_ITEM = "固定好码头。",	-- 物品名:"码头桩"
		
		FISH_BOX = "保存鱼。",		-- 物品名:"锡鱼罐" 制造描述:"保持鱼与网捕之日一样新鲜。"
	------ 装饰分类
		FENCE_ROTATOR = "适合强迫症的工具。",	-- 物品名:"栅栏击剑"
		PUMPKIN_LANTERN = "也许可以把它挂起来？",		-- 物品名:"南瓜灯" 制造描述:"长着鬼脸的照明用具。"
		FEATHERPENCIL = "可以书写与绘画。颉和夕争论字画同源的时候，谁又能想到会发生那件事……",		-- 物品名:"羽毛笔" 制造描述:"是的，羽毛是必须的。"
		-- 木栅栏
		FENCE = "篱落疏疏一径深，树头花落未成阴。",		-- 物品名:"木栅栏"
		FENCE_ITEM = "织木结篱。",		-- 物品名:"木栅栏"->携带物状态 制造描述:"木栅栏部分。"
		-- 木门
		FENCE_GATE = "普通的木门。",		-- 物品名:"木门"
		FENCE_GATE_ITEM = "总比没有门强。",		-- 物品名:"木门"->携带物状态 制造描述:"木栅栏的门。"
		-- 盆栽
		POTTEDFERN = "盆里的蕨类植物。",		-- 物品名:"蕨类盆栽" 制造描述:"做个花盆，里面栽上蕨类植物。"
		SUCCULENT_POTTED = "盆里的多肉植物。",		-- 物品名:"多肉盆栽" 制造描述:"塞进陶盆的漂亮多肉植物。"
        -- 假人		
		SEWING_MANNEQUIN =
		{
			GENERIC = "也只是假象。",	-- 物品名:"假人" 制造描述:"测试所有最新可装备外观的模特。"
			BURNT = "火焰吞噬了它。",		-- 物品名:"假人" 制造描述:"测试所有最新可装备外观的模特。"
		},
		-- 蘑菇灯
		MUSHROOM_LIGHT =
		{
			ON = "发光的巨蕈。",		-- 物品名:"蘑菇灯"->开启 制造描述:"任何蘑菇的完美添加物。"
			OFF = "给它浇点酒会不会继续长大？",		-- 物品名:"蘑菇灯"->关闭 制造描述:"任何蘑菇的完美添加物。"
			BURNT = "完全烧焦。",		-- 物品名:"蘑菇灯"->烧焦的 制造描述:"任何蘑菇的完美添加物。"
		},
		-- 菌伞灯
		MUSHROOM_LIGHT2 =
		{
			ON = "虽然这些菌蕈不能酿酒，用做照明倒也不错。",		-- 物品名:"菌伞灯"->开启 制造描述:"受到火山岩浆灯饰学问的激发。"
			OFF = "也许它能改变颜色。",		-- 物品名:"菌伞灯"->关闭 制造描述:"受到火山岩浆灯饰学问的激发。"
			BURNT = "繁华三千，一炬皆倾。",		-- 物品名:"菌伞灯"->烧焦的 制造描述:"受到火山岩浆灯饰学问的激发。"
		},
		-- 鱼类计重器
		TROPHYSCALE_FISH =
		{
			GENERIC = "专业的称量工具。",		-- 物品名:"鱼类计重器"->默认 制造描述:"炫耀你的斩获。"
			HAS_ITEM = "重量: {weight}\n捕获人: {owner}中规中矩。",		-- 物品名:"鱼类计重器"->称重别人的普通海鱼 制造描述:"炫耀你的斩获。"
			HAS_ITEM_HEAVY = "重量: {weight}\n捕获人: {owner}\n所获颇丰!",		-- 物品名:"鱼类计重器"->称重别人的重量型海鱼 制造描述:"炫耀你的斩获。"
			BURNING = "称个鱼也能这么燃吗？",		-- 物品名:"鱼类计重器"->正在燃烧 制造描述:"炫耀你的斩获。"
			BURNT = "诶呦，可惜了这么大的鱼。",		-- 物品名:"鱼类计重器"->烧焦的 制造描述:"炫耀你的斩获。"
			OWNER = "也不算一无所获。\n重量: {weight}\n捕获人: {owner}",		-- 物品名:"鱼类计重器"->称重自己的普通海鱼 制造描述:"炫耀你的斩获。"
			OWNER_HEAVY = "重量: {weight}\n捕获人: {owner}\n只是一条稍重的鱼，也没什么好炫耀的。",		-- 物品名:"鱼类计重器"->称重自己的重量型海鱼 制造描述:"炫耀你的斩获。"
		},
        -- 锯马
		CARPENTRY_STATION =
		{
			GENERIC = "专业的家具制造台。",	-- 物品名:"锯马"->默认 制造描述:"别瞎蹦跶了，做点家具吧。"
			BURNT = "再怎么专业也还是逃不开火灾。",	-- 物品名:"锯马"->烧毁 制造描述:"别瞎蹦跶了，做点家具吧。"
		},
	    -- 木椅
		WOOD_CHAIR =
		{
			GENERIC = "虚位待知音，尘落听风吟。",	-- 物品名:"木椅"->无人 制造描述:"一把可以坐的木椅。"
			OCCUPIED = "屈伸随人意，吱呀话家常。",	-- 物品名:"木椅"->有人 制造描述:"一把可以坐的木椅。"
			BURNT = "焦骨委地碎，难复旧时形。",	-- 物品名:"木椅"->烧毁 制造描述:"一把可以坐的木椅。"
		},

		DECOR_CENTERPIECE = "无趣的装潢。",	-- 物品名:"艺术？" 制造描述:"彰显您卓越品味的餐桌摆件。"
		DECOR_LAMP = "案前灯曳。",	-- 物品名:"餐桌灯" 制造描述:"一盏舒适的小灯。"
        -- 餐桌花瓶
		DECOR_FLOWERVASE =
		{
			GENERIC = "借得三分水，报以十分春。",	-- 物品名:"餐桌花瓶"->有花 制造描述:"这是一个放置鲜切花的好地方。"
			EMPTY = "空待折枝花满衣。",	-- 物品名:"餐桌花瓶"->无物品 制造描述:"这是一个放置鲜切花的好地方。"
			WILTED = "残香萦空枝，褪色映黄昏。",	-- 物品名:"餐桌花瓶"->有花且已腐败 制造描述:"这是一个放置鲜切花的好地方。"
			FRESHLIGHT = "点点微萤。",	-- 物品名:"餐桌花瓶"->有发光物品 制造描述:"这是一个放置鲜切花的好地方。"
			OLDLIGHT = "星光散，腐萤生。",	-- 物品名:"餐桌花瓶"->有发光物品且已腐败 制造描述:"这是一个放置鲜切花的好地方。"
		},
        -- 空画框
		DECOR_PICTUREFRAME =
		{
			GENERIC = "看起来还不错。",	-- 物品名:"{item}画" 制造描述:"将你最爱的物品图装裱起来。"
			UNDRAWN = "拙山尽。",	-- 物品名:"空画框" 制造描述:"将你最爱的物品图装裱起来。"
		},

		DECOR_PORTRAITFRAME = "它们以前的元元，罢了，就让岁月给出回答吧。",	-- 物品名:"愉快画像" 制造描述:"把你的朋友们放进框里，这很有趣！"
		-- 留声机&唱片
		PHONOGRAPH = "看起来还不错的留声机。",	-- 物品名:"留声机" 制造描述:"坐下来，放松一下，听一听你噩梦中的音乐。"
		RECORD = "做工精致，品质不错。",	-- 物品名:"唱片" 制造描述:"黑胶上的永恒经典。"
		RECORD_CREEPYFOREST = "做工精致，品质不错。",	-- 物品名:"惊悚森林" 制造描述:"黑胶上的永恒经典。"
		RECORD_DANGER = "倦了。",	-- 物品名:"唱片" 制造描述:"黑胶上的永恒经典。"
		RECORD_DAWN = "倦了。",	-- 物品名:"唱片" 制造描述:"黑胶上的永恒经典。"
		RECORD_DRSTYLE = "做工精致，品质不错。",	-- 物品名:"D.R.风格" 制造描述:"黑胶上的永恒经典。"
		RECORD_DUSK = "倦了。",	-- 物品名:"唱片" 制造描述:"黑胶上的永恒经典。"
		RECORD_EFS = "倦了。",	-- 物品名:"E.F.S." 制造描述:"黑胶上的永恒经典。"
		RECORD_END = "做工精致，品质不错。",	-- 物品名:"唱片" 制造描述:"黑胶上的永恒经典。"
		RECORD_MAIN = "倦了。",	-- 物品名:"唱片" 制造描述:"黑胶上的永恒经典。"
		RECORD_WORKTOBEDONE = "倦了。",	-- 物品名:"唱片" 制造描述:"黑胶上的永恒经典。"
	------ 远古科技分类
		-- 远古科技
		ANCIENT_ALTAR = "古老文明留下的辉煌遗产。",		-- 物品名:"远古伪科学站"
		ANCIENT_ALTAR_BROKEN = "天开月明，海走冰散，岁月总会抹去往昔的辉煌。",		-- 物品名:"损坏的远古伪科学站"
		-- 铥矿
		THULECITE = "远古的遗产。",		-- 物品名:"铥矿" 制造描述:"将小碎片合成一大块。"
		THULECITE_PIECES = "更小的铥矿。",		-- 物品名:"铥矿碎片"
		-- 铥矿装备
		MULTITOOL_AXE_PICKAXE = "高明的手法。",		-- 物品名:"多用斧镐" 制造描述:"加倍实用。"
		RUINS_BAT = "不算趁手，但效果很好。",		-- 物品名:"铥矿棒" 制造描述:"尖钉让一切变得更好。"
		RUINSHAT = "不错的装饰，可惜我不喜欢王冠的沉重",		-- 物品名:"铥矿皇冠" 制造描述:"附有远古力场！"
		ARMORRUINS = "夕都能轻松穿着它跑步。",		-- 物品名:"铥矿甲" 制造描述:"炫目并且能提供保护。"
		-- 眼球塔
		EYETURRET = "希望你能喜欢看尽四海八荒的感觉。",		-- 物品名:"眼睛炮塔"
		EYETURRET_ITEM = "它在睡觉。",		-- 物品名:"眼睛炮塔"->携带状态 制造描述:"要远离讨厌的东西，就得杀了它们。"
		-- 铥矿徽章
		NIGHTMARE_TIMEPIECE =
		{
			CALM = "结束了，在魔力下次暴动前做点什么吧。",		-- 物品名:"铥矿徽章"->暴动结束 制造描述:"跟踪周围魔力水平的流动。"
			WARN = "这里有相当强的魔法能量。",		-- 物品名:"铥矿徽章"->暴动开始 制造描述:"跟踪周围魔力水平的流动。"
			WAXING = "这些能量越来越密集了！",		-- 物品名:"铥矿徽章"->暴动加剧 制造描述:"跟踪周围魔力水平的流动。"
			STEADY = "保持正在稳定状态了。",		-- 物品名:"铥矿徽章"->暴动最猛烈 制造描述:"跟踪周围魔力水平的流动。"
			WANING = "魔法能量正在减弱。",		-- 物品名:"铥矿徽章"->暴动减弱 制造描述:"跟踪周围魔力水平的流动。"
			DAWN = "暴动就要结束了。",		-- 物品名:"铥矿徽章"->暴动即将结束 制造描述:"跟踪周围魔力水平的流动。"
			NOMAGIC = "这里没有魔法能量，没法用它侦测。",		-- 物品名:"铥矿徽章"->非远古区域 制造描述:"跟踪周围魔力水平的流动。"
		},
		
		--未知  SLURPERPELT = "还是好多毛。",		-- 物品名:"啜食者皮"->啜食者皮
    	THULECITEBUGNET = "也许有些东西需要用到这么精致的捕虫网去捕捉。", --  铥矿捕虫网
	   	NUTRIENTSGOGGLESHAT = "看清泥土中隐藏的秘密。",		-- 物品名:"高级耕作先驱帽"

	-----宝石魔法分类
		-- 宝石
		BLUEGEM = "一颗蓝色的，冰凉的宝石。",		-- 物品名:"蓝宝石"
		REDGEM = "一颗红色的宝石，除了火焰，它还隐藏着其他的力量。",		-- 物品名:"红宝石"
		PURPLEGEM = "一颗紫色的宝石，似乎蕴含着更多黑暗的力量。",		-- 物品名:"紫宝石" 制造描述:"结合你们的颜色！"
		YELLOWGEM = "一颗黄色的，亮堂堂的宝石。",		-- 物品名:"黄宝石"
		ORANGEGEM = "一颗橙色的，捉摸不定的宝石。",		-- 物品名:"橙宝石"
		GREENGEM = "一颗绿色的宝石，闪耀着奇特的光芒。",		-- 物品名:"绿宝石"
		OPALPRECIOUSGEM = "多彩绚丽的宝石。",		-- 物品名:"彩虹宝石"
		-- 护符
		BLUEAMULET = "如霜降。",		-- 物品名:"寒冰护符" 制造描述:"多么冰冷酷炫的护符。"
		AMULET = "死亡的新生。",		-- 物品名:"重生护符" 制造描述:"逃离死神的魔爪。"
		PURPLEAMULET = "只是幻觉罢了，我与我周旋良久，早已不会害怕一个如梦般的泡影。",		-- 物品名:"梦魇护符" 制造描述:"引起精神错乱。"
		YELLOWAMULET = "手感温暖。",		-- 物品名:"魔光护符" 制造描述:"从天堂汲取力量。"
		ORANGEAMULET = "探囊取物，不费吹灰之力。",		-- 物品名:"懒人护符" 制造描述:"适合那些不喜欢捡东西的人。"
		GREENAMULET = "假借须臾的小把戏。",		-- 物品名:"建造护符" 制造描述:"用更少的材料合成物品！"
		-- 魔杖
		ICESTAFF = "美丽“冻”人。",		-- 物品名:"冰魔杖" 制造描述:"把敌人冰冻在原地。"
		FIRESTAFF = "不可滥用。",		-- 物品名:"火魔杖" 制造描述:"利用火焰的力量！"
		TELESTAFF = "它借助暗影的力量放逐生物。",		-- 物品名:"传送魔杖" 制造描述:"穿越空间的法杖！时间要另外收费。"
		YELLOWSTAFF = "手握星辰。",		-- 物品名:"唤星者魔杖" 制造描述:"召唤一个小星星。"
		ORANGESTAFF = "快人一步。",		-- 物品名:"懒人魔杖" 制造描述:"适合那些不喜欢走路的人。"
		GREENSTAFF = "或许我不该对着嗡嗡叫的书使用。",		-- 物品名:"拆解魔杖" 制造描述:"干净而有效的摧毁。"
		OPALSTAFF = "经过月光的洗礼，法杖上的宝石更加绚丽了。",		-- 物品名:"唤月者魔杖"

		STAFFLIGHT = "丽日绰约。",		-- 物品名:"矮星"
		STAFFCOLDLIGHT = "霜冷月寂。",		-- 物品名:"极光"
		-- 传送焦点
		TELEBASE =
		{
			VALID = "准备万全。",		-- 物品名:"传送焦点"->有效 制造描述:"装上宝石试试。"
			GEMS = "我应该准备更多紫宝石。",		-- 物品名:"传送焦点"->需要宝石 制造描述:"装上宝石试试。"
		},
		-- 紫宝石基座
		GEMSOCKET =
		{
			VALID = "这个没问题了。",		-- 物品名:"宝石底座"->有效
			GEMS = "它需要一颗紫宝石。",		-- 物品名:"宝石底座"->需要宝石
		},
	------ 暗影术基座科技分类
		SHADOW_FORGE = "使用这个基座将暗影塑形。",	-- 物品名:"暗影术基座"
		SHADOW_FORGE_KIT = "得找个地方组装起来。",	-- 物品名:"暗影术基座套装" 制造描述:"让恐惧为你所用。"
		-- 暗影c材料&消耗品
		VOIDCLOTH = "奇怪的材质，但是能使用暗影的力量重新缝合。",	-- 物品名:"暗影碎布"
		GELBLOB_BOTTLE = "我认为把这些东西存进瓶子里更好。",	--物品名:"恶液瓶"
		VOIDCLOTH_KIT = "缝缝补补还能用。",	-- 物品名:"虚空修补套件" 制造描述:"修复损坏的设备。"

		-- 绝望石防具
		ARMORDREADSTONE = "你想在“我”心里挖掘恐惧？",	-- 物品名:"绝望石盔甲" 制造描述:"不要怕，黑暗会保护你。"
		DREADSTONEHAT = "似乎没什么令人绝望的东西。",	-- 物品名:"绝望石头盔" 制造描述:"由至黑的石头做成的结实头盔。"
		
		-- 虚空防具
		VOIDCLOTHHAT = "很像三位“特使”的服饰，只是多了梦魇的气息。",	-- 物品名:"虚空风帽" 制造描述:"没有光可以刺穿这个罩子里的黑暗。"
		ARMOR_VOIDCLOTH = "凶狠的服饰。",	-- 物品名:"虚空长袍" 制造描述:"一件阻隔光线的噩梦斗篷。"
		-- 虚空武器
		VOIDCLOTH_SCYTHE = "一挥断生死，再挥盈仓廪。",	-- 物品名:"暗影收割者" 制造描述:"从容地剔除植物群落。"
		SHADOW_BATTLEAXE = "你渴望的杀戮毫无意义。",	--物品名:"暗影槌" 制造描述:"用这把大锤砍倒一切。"
		VOIDCLOTH_BOOMERANG = "不用自己接住就是好。",	--物品名:"阴郁回旋镖" 制造描述:"它会一直回来！"
		-- 虚空工具
		SADDLE_SHADOW = "看起来还行。",	--物品名:"梦魇鞍具" 制造描述:"抓住缰绳，统治战场。"
		SHADOW_BEEF_BELL = "用梦魇的力量将死去的丰蹄朋友带回来。",	--物品名:"阴郁皮弗娄牛铃铛" 制造描述:"复活你的那个牛朋友。"
		VOIDCLOTH_UMBRELLA = "使用暗影的力量抵御强酸。",	-- 物品名:"暗影伞" 制造描述:"暗影提供的保护，不惧最严峻的降雨。"
		-- 防腐喷雾
		BEESWAX_SPRAY = "永恒的代价是死亡。",	--物品名:"防腐喷雾"
		WAXED_PLANT = "它被永恒冻结在恐惧中.", -- 被防腐喷雾喷过的植物
		-- 恶液储存箱
		GELBLOB_STORAGE_KIT = "有效保存食物。",	--物品名:"恶液储存箱套件" 制造描述:"这种致命的黑色果冻可以让您的易腐烂物品保持新鲜。"
		GELBLOB_STORAGE = 
		{ 
			GENERIC  = "用这种特殊的物质可以永久保存食物。",	--物品名:"恶液储存箱"->没东西
			FULL = "就像是被定格一样。",	--物品名:"恶液储存箱"->有东西
		},
		-- 绝望石墙
		WALL_DREADSTONE = "绝境逢生。",                   -- 绝望石墙(建筑)
		WALL_DREADSTONE_ITEM = "无异于火上浇油。",	-- 物品名:"绝望石墙"->携带物状态 制造描述:"将自己包围在最可怕的装饰之中。"
		-- 绝望石支柱
		SUPPORT_PILLAR_DREADSTONE_SCAFFOLD = "用绝望石支撑并加固洞穴穹顶。",	-- 物品名:"绝望石支柱脚手架" 制造描述:""
		SUPPORT_PILLAR_DREADSTONE = "噩梦能自行汲取能量修复自身，暂时不必担心。",	-- 物品名:"绝望石支柱"
		SUPPORT_PILLAR_DREADSTONE_COMPLETE = "坚不可摧。",	-- 物品名:"加固绝望石支柱"
		SUPPORT_PILLAR_DREADSTONE_BROKEN = "只有刻意的破坏才能让它倒下。",	-- 物品名:"绝望石支柱瓦砾"
	----- 普通天体科技
		MOONROCKSEED = "手捧舒月，可摘星晨。",		-- 物品名:"天体宝球"
		-- 天体材料
		MOONGLASS = "锋利的碎琉璃。",		-- 物品名:"月亮碎片"
		MOONGLASS_CHARGED = "拥有浓郁多少月亮魔力。",		-- 物品名:"注能月亮碎片"
		CARPENTRY_BLADE_MOONGLASS = "用更锋利的锯片加工石材。",	--物品名:"月光玻璃锯片" 制造描述:"当普通刀片无法切割时使用。"
		-- 玻璃武器
		MOONGLASSAXE = "斫桂月痕万古新，清辉落刃无穷已。",		-- 物品名:"月光玻璃斧" 制造描述:"脆弱而有效。"
		GLASSCUTTER = "清光一闪寒芒逝，新月琉璃斩梦魇。",		-- 物品名:"玻璃刀" 制造描述:"尖端武器。"
		-- 沐浴球
		BATHBOMB = "这点芒硝会让泉水沸腾很久了。",		-- 物品名:"沐浴球" 制造描述:"春天里来百花香？这点子把地都炸碎了"
		-- 杂项
		SENTRYWARD = "通过月亮的力量监控一片区域。",		-- 物品名:"月眼守卫" 制造描述:"绘图者最有价值的武器。"
		MOONROCKIDOL = "向这个世界的月亮许愿。",		-- 物品名:"月岩雕像" 制造描述:"重要人物。"
    ------ 辉煌锻造台科技
		LUNAR_FORGE = "使用月亮的能量锻造与强化。",	-- 物品名:"辉煌铁匠铺"
		LUNAR_FORGE_KIT = "得动手组装起来。",	-- 物品名:"辉煌铁匠铺套装" 制造描述:"锻造异世界的物品。"
		-- 消耗品
		LUNARPLANT_KIT = "使用满满的能量修复月亮装备。",	-- 物品名:"亮茄修补套件" 制造描述:"修复损坏的设备。"
		BROKEN_FORGEDITEM = "使用专用的修补套件就能修好。",	-- 物品名:"损坏的亮茄装备"
		CHESTUPGRADE_STACKSIZE = "来自月亮的魔法技术。",	-- Describes the kit upgrade item.	-- 物品名:"弹性空间制造器" 制造描述:"为了一些存储空间，多少有点揠苗助长了。"
		-- 亮茄防具
		ARMOR_LUNARPLANT = "坚硬的藤甲。",	-- 物品名:"亮茄盔甲" 制造描述:"将自己包围在令人生畏的月叶中。"
		LUNARPLANTHAT = "有点圧头发。",	-- 物品名:"亮茄头盔" 制造描述:"用发着光的护具保护您宝贵的颅骨。"
		-- 亮茄武器
		BOMB_LUNARPLANT = "不如抬头看看？",	-- 物品名:"亮茄炸弹" 制造描述:"用不稳定的月能取得爆炸性结果。"
		STAFF_LUNARPLANT = "保存距离。",	-- 物品名:"亮茄魔杖" 制造描述:"扎根原地，从远处发起攻击。"
		SWORD_LUNARPLANT = "月光宝剑。",	-- 物品名:"亮茄剑" 制造描述:"月光宝剑。"
		-- 亮茄工具
		PICKAXE_LUNARPLANT = "使用月能敲碎石头与建筑。",	-- 物品名:"亮茄粉碎者" 制造描述:"随心所欲地挖掘和拆除吧。"
		SHOVEL_LUNARPLANT = "除了挖地还可以锄地，很高效的设计。",	-- 物品名:"亮茄铲子" 制造描述:"铲子和园艺锄之间交叉授粉的突破性成果。"
		--火花柜
		SECURITY_PULSE_CAGE = "独特的装置，专门针对脉冲能量进行约束。",	-- 火花柜(未充能)
		SECURITY_PULSE_CAGE_FULL = "你还是呆在这里面更好。",	-- 火花柜(已充能)
		-- 火花柜装备
		BEARGERFUR_SACK = "用月能做的便携冰箱。",	-- 物品名:"极地熊獾桶" 制造描述:"便携式冰箱。酷。"
		HOUNDSTOOTH_BLOWPIPE = "奇怪但有效的设计。",	-- 物品名:"嚎弹炮" 制造描述:"那感觉就像远距离被咬一样。"
		-- 冰眼结晶器
		DEERCLOPSEYEBALL_SENTRYWARD =
		{
			GENERIC = "凝聚冰霜的力量。",	-- Enabled.	-- 物品名:"冰眼结晶器"->有眼珠
			NOEYEBALL = "看来得某人贡献一下自己的眼睛了。", -- 物品名:"冰眼结晶器"->无眼珠
		},
		DEERCLOPSEYEBALL_SENTRYWARD_KIT = "要让哪里变成冰河时代呢？",	-- 物品名:"冰眼结晶器套装" 制造描述:"用冻伤来治疗一下晒伤。"
	------ 随从与宠物
		-- 切斯特
		CHESTER = "你也有自己的想法吗，箱子先生。",		-- 物品名:"切斯特"
		-- 眼骨-切斯特信物
		CHESTER_EYEBONE =
		{
			GENERIC = "想不想来我的梦里看看？",		-- 物品名:"眼骨"->默认
			WAITING = "它会回来的，就像以前一样，一如既往。",		-- 物品名:"眼骨"->死了等待复活
		},
		-- 哈奇
		HUTCH = "你也在挑灯寻梦吗？",		-- 物品名:"哈奇"
		-- 星空--哈奇信物
		HUTCH_FISHBOWL =
		{
			GENERIC = "你和北冥的鱼一样，向往无垠的星空？",		-- 物品名:"星空"->默认
			WAITING = "它会回来的，就像以前一样。",		-- 物品名:"星空"->需要等待
		},
		-- 格罗姆
		GLOMMER =
		{
			GENERIC = "看着还行。",		-- 物品名:"格罗姆"->默认
			SLEEPING = "梦里它还会抓蝴蝶吃吗？",		-- 物品名:"格罗姆"->睡着了
		},
		-- 格罗姆花-格罗姆信物
		GLOMMERFLOWER =
		{
			GENERIC = "花瓣微微发亮。",		-- 物品名:"格罗姆花"->默认
			DEAD = "花瓣枯萎，微微发亮。",		-- 物品名:"格罗姆花"->死了
		},
		-- 格罗姆雕像-格罗姆出生点
		STATUEGLOMMER =
		{
			GENERIC = "奇怪的生物雕像。",		-- 物品名:"格罗姆雕像"->默认
			EMPTY = "国蚀器锈，如梦似电，无踪泡影。",		-- 物品名:"格罗姆雕像"->被开采
		},
		GLOMMERWINGS = "这么小的翅膀怎么支撑它飞起来的？",		-- 物品名:"格罗姆翅膀"
		GLOMMERFUEL = "一股臭味。",		-- 物品名:"格罗姆的黏液"
		-- 瓦器人
		STORAGE_ROBOT = {
			GENERIC = "瓦格斯塔夫的全自动小帮手。",	--物品名:"瓦器人"->默认
			BROKEN = "也许有办法修好它。",	--物品名:"瓦器人"->损坏
		},
		-- 波莉·罗杰
		POLLY_ROGERSHAT = "你要陪伴我征服大海吗？",	-- 物品名:"波莉·罗杰的帽子"
		POLLY_ROGERS = "总会有只黎博利不知道事情的真相。",	-- 物品名:"波莉·罗杰"
		-- 友好果蝇
		FRIENDLYFRUITFLY = "这只小可爱“自愿”照顾花园。",		-- 物品名:"友好果蝇"
		FRUITFLYFRUIT = "它很信赖我。",		-- 物品名:"友好果蝇果"
		-- 幼年的高脚鸟
		-- 孵化中的高脚鸟蛋
		TALLBIRDEGG_CRACKED =
		{
			COLD = "它冷的直打哆嗦。",		-- 物品名:"孵化中的高脚鸟蛋"->冷了
			GENERIC = "它在努力生长。",		-- 物品名:"孵化中的高脚鸟蛋"->默认
			HOT = "它似乎红温了，得让它冷静一下。",		-- 物品名:"孵化中的高脚鸟蛋"->热了
			LONG = "新生命的诞生需要耐心，",		-- 物品名:"孵化中的高脚鸟蛋"->还需要很久
			SHORT = "它在努力破壳。",		-- 物品名:"孵化中的高脚鸟蛋"->很快了
		},
		-- 小高脚鸟
		SMALLBIRD =
		{
			GENERIC = "它怎么长出那么长腿的？",		-- 物品名:"小鸟"（幼年高脚鸟）->默认
			HUNGRY = "嗷嗷待哺。",		-- 物品名:"小鸟"（幼年高脚鸟）->有点饿了
			STARVING = "它一定很饿。",		-- 物品名:"小鸟"（幼年高脚鸟）->挨饿
			SLEEPING = "它还是很警惕。",		-- 物品名:"小鸟"（幼年高脚鸟）->睡着了
		},
		-- 青年高脚鸟
		TEENBIRD =
		{
			GENERIC = "不是很高的鸟。",		-- 物品名:"小高脚鸟"（青年高脚鸟）->默认
			HUNGRY = "你消化的这么快吗？",		-- 物品名:"小高脚鸟"（青年高脚鸟）->有点饿了
			STARVING = "总感觉它喂不熟。",		-- 物品名:"小高脚鸟"（青年高脚鸟）->挨饿
			SLEEPING = "它还是对我抱有敌意。",		-- 物品名:"小高脚鸟"（青年高脚鸟）->睡着了
		},
		-- 宠物
		CRITTERLAB = "那里面有什么东西在看着我。",		-- 物品名:"岩石巢穴"
		CRITTER_GLOMLING = "比以前更可爱了。",		-- 物品名:"小格罗姆"
		CRITTER_DRAGONLING = "它会长大吗？",		-- 物品名:"小龙蝇"
		CRITTER_LAMB = "比起它妈妈，它的粘液少多了。",		-- 物品名:"小钢羊"
		CRITTER_PUPPY = "可爱的小狼。",		-- 物品名:"小座狼"
		CRITTER_KITTEN = "如果你在在箱子里会是什么状态呢？",		-- 物品名:"小浣猫"
		CRITTER_PERDLING = "天亮时你会叫醒我吗？",		-- 物品名:"小火鸡"
		CRITTER_LUNARMOTHLING = "得让它离火远些。",		-- 物品名:"小蛾子"
		CRITTER_EYEOFTERROR = "至少它学到教训了。",		-- 物品名:"友好窥视者"
		-- 超级可爱岩浆虫
		LAVAE_PET =
		{
			STARVING = "小家伙，你一定是饿了。",		-- 物品名:"超级可爱岩浆虫"->挨饿
			HUNGRY = "你想吃什么呢？",		-- 物品名:"超级可爱岩浆虫"->有点饿了
			CONTENT = "它似乎很快乐。",		-- 物品名:"超级可爱岩浆虫"->满足
			GENERIC = "谁是好怪物？",		-- 物品名:"超级可爱岩浆虫"->默认
		},
		-- 岩浆虫卵
		LAVAE_EGG =
		{
			GENERIC = "一枚温热的卵,需要充足的热量来孵化。",		-- 物品名:"岩浆虫卵"->默认
		},
		-- 孵化中的岩浆虫卵
		LAVAE_EGG_CRACKED =
		{
			COLD = "温度太低了，得生堆火。",		-- 物品名:"冻伤"->冷了
			COMFY = "看来你很舒服。",		-- 物品名:"岩浆虫卵"->舒服的
		},
		LAVAE_COCOON = "在这样的温度下，这枚卵无法存活。",		-- 物品名:"冷冻虫卵"
		LAVAE_TOOTH = "一颗牙，是送给我的吗？",		-- 物品名:"岩浆虫尖牙"
-------- 自然资源与生物---------------------------------------------------------------------------------
	------ 地图资源
		-- 花
		FLOWER =
		{
			GENERIC = "花开千年，花落千年。",		-- 物品名:"花"->默认
			ROSE = "愈是美丽，愈是危险。",		-- 物品名:"花"->玫瑰
		},
		FLOWER_WITHERED = "没有太阳的照射让它失去生机。",		-- 物品名:"枯萎的花"
		FLOWER_EVIL = "被魔力浸染，最好不要去碰它。",		-- 物品名:"邪恶花"
		
		PETALS = "胭脂碎映春风纹，香魂犹附残露痕。",		-- 物品名:"花瓣"
		PETALS_EVIL = "被黑暗“赐福”的花。",		-- 物品名:"恶魔花瓣"
        -- 萤火虫
		FIREFLIES =
		{
			GENERIC = "宵烛散流星，腐草化飞萤。",		-- 物品名:"萤火虫"->默认
			HELD = "掌中流光逝，宵烛困方寸。",		-- 物品名:"萤火虫"->拿在手里
		},
		-- 食人花
		LUREPLANT = "它捕猎用的诱饵或许能用得上。",		-- 物品名:"食人花"
		EYEPLANT = "想喝一杯吗？",		-- 物品名:"眼球草"
		LUREPLANTBULB = "现在我可以在任何地方栽种它了。",		-- 物品名:"食人花种子"
		-- 虫洞
		WORMHOLE =
		{
			GENERIC = "奇怪的生物，不过它对我没有敌意。",		-- 物品名:"虫洞"->默认
			OPEN = "事已至此，只能快速去那边了。",		-- 物品名:"虫洞"->打开
		},
		-- 亡魂
		GHOSTFLOWER = "亡魂给予她的馈赠。",		-- 物品名:"哀悼荣耀"
		SMALLGHOST = "短命的小家伙。",		-- 物品名:"小惊吓"
		-- 龙虾
		WOBSTER_SHELLER = "鲜甜破坚牢，嚼月镇宴潮。",		-- 物品名:"龙虾"
		WOBSTER_DEN = "水中的礁石，龙虾把它当作巢穴。",		-- 物品名:"龙虾窝"
		WOBSTER_SHELLER_DEAD = "任人宰割的龙虾才是好龙虾。",		-- 物品名:"死龙虾"
		WOBSTER_SHELLER_DEAD_COOKED = "赤甲熔霜脂，揭盖涌琼膏。",		-- 物品名:"美味的龙虾"

		WOBSTER_MOONGLASS = "不要盲目追随大众的趋势，虽然你没得选。",		-- 物品名:"月光龙虾"
		MOONGLASS_WOBSTER_DEN = "随意“装龙虾”的后果。",		-- 物品名:"月光玻璃窝"
		-- 公牛海带
		BULLKELP_PLANT =
		{
			GENERIC = "墨犄劈海裂，玄绦缚龙筋。",		-- 物品名:"公牛海带"->默认
			PICKED = "他会长出来的。",		-- 物品名:"公牛海带"->被采完了
		},
		BULLKELP_ROOT = "找个地方栽种。",		-- 物品名:"公牛海带茎"
		-- 海草
		WATERPLANT = "也许可以靠它当饵料。",		-- 物品名:"海草"
		WATERPLANT_BOMB = "不要随意丢弃。",		-- 物品名:"种壳"
		WATERPLANT_BABY = "它在生长。",		-- 物品名:"海芽"
		WATERPLANT_PLANTER = "在海上的礁石上可以生根发芽。",		-- 物品名:"海芽插穗"
		-- 海星陷阱
		TRAP_STARFISH =
		{
			GENERIC = "或许该离它远点，我有股不好的感觉。",		-- 物品名:"海星"->默认
			CLOSED = "诶呦，小心脚下。",		-- 物品名:"海星"->合上了
		},
		DUG_TRAP_STARFISH = "也许能整蛊他人。",		-- 物品名:"海星陷阱"->携带物状态
	------ 生物&掉落物&刷新点&战利品/掉落物
	------ 小动物
		-- 蝴蝶
		BUTTERFLY =
		{
			GENERIC = "是我梦见你，还是你梦见了我？",		-- 物品名:"蝴蝶"->默认
			HELD = "兴许是我梦见了你。",		-- 物品名:"蝴蝶"->拿在手里
		},
		BUTTERFLYWINGS = "没有翅膀，也依旧向往天空。",		-- 物品名:"蝴蝶翅膀"
		-- 月蛾
		MOONBUTTERFLY =
		{
			GENERIC = "受月亮影响的蝴蝶，命不久矣。",		-- 物品名:"月蛾"->默认
			HELD = "我与你，又有何不同呢？",		-- 物品名:"月蛾"->拿在手里
		},
		MOONBUTTERFLYWINGS = "飞蛾翅膀，有独特的美感。美丽的代价，是致命的魔力。",		-- 物品名:"月蛾翅膀"
		-- 兔子
		RABBIT =
		{
			GENERIC = "蹦蹦跳跳的卡特斯，真可爱。",		-- 物品名:"兔子"->默认
			HELD = "你头上的小角好可爱。",		-- 物品名:"兔子"->拿在手里
		},
		-- 兔子洞
		RABBITHOLE =
		{
			GENERIC = "狡兔三窟，看起来它并没有那么狡黠。",		-- 物品名:"兔洞"->默认
			SPRING = "看来是春天的第一场雨泡塌了你的窝。",		-- 物品名:"兔洞"->春天兔子洞塌陷
		},
		-- 鼹鼠
		MOLE =
		{
			HELD = "没什么可挖的了，我的朋友。",		-- 物品名:"鼹鼠"->拿在手里
			UNDERGROUND = "下面有个正在寻找矿物的家伙。",		-- 物品名:"鼹鼠"->在地下
			ABOVEGROUND = "我想像打地鼠那样敲昏那只鼹鼠...",		-- 物品名:"鼹鼠"->钻出来了
		},
		MOLEHILL = "硕鼠硕鼠，无食我黍！",		-- 物品名:"鼹鼠洞"
		-- 乌鸦
		CROW =
		{
			GENERIC = "很久以前，人们尊称你为玄鸟，可现在它们却都认为你会带来灾祸。",		-- 物品名:"乌鸦"->默认
			HELD = "你的羽毛是五彩斑斓的绚丽，可人们都认为那是黑色。",		-- 物品名:"乌鸦"->拿在手里
		},
		FEATHER_CROW = "玄鸟的羽毛，可惜那些华光已经不见了。",		-- 物品名:"黑色羽毛"
		-- 红雀
		ROBIN =
		{
			GENERIC = "朱羽燃空碧，啼破一山春。",		-- 物品名:"红雀"->默认
			HELD = "它没有特别慌张。",		-- 物品名:"红雀"->拿在手里
		},
		FEATHER_ROBIN = "红雀的羽毛。",		-- 物品名:"红色羽毛"
		-- 雪雀
		ROBIN_WINTER =
		{
			GENERIC = "冰羽裁霁色，寒枝缀碎晶。",		-- 物品名:"雪雀"->默认
			HELD = "想吃点什么吗？",		-- 物品名:"雪雀"->拿在手里
		},
		FEATHER_ROBIN_WINTER = "雪雀的羽毛。",		-- 物品名:"蔚蓝羽毛"
				ROBOT_PUPPET = "天下没有免费的午餐哦。",-- 单机遗留，雪雀		-- 物品名:"雪雀"

        -- 金丝雀
		CANARY =
		{
			GENERIC = "金色华丽的小鸟。",		-- 物品名:"金丝雀"->默认
			HELD = "你要在我的手中跳舞吗？",		-- 物品名:"金丝雀"->拿在手里
		},
		FEATHER_CANARY = "金丝雀的羽毛。",		-- 物品名:"黄色羽毛"
		CANARY_POISONED = "它对这里的孢子过敏。",		-- 物品名:"金丝雀（中毒）"
		-- 海鹦鹉
		PUFFIN =
		{
			GENERIC = "玄裳雪羽击浪深，终古不栖岸汀尘。",		-- 物品名:"海鹦鹉"->默认
			HELD = "你会向往陆地吗。",		-- 物品名:"海鹦鹉"->拿在手里
			SLEEPING = "在波涛中安眠。",		-- 物品名:"海鹦鹉"->睡着了
		},
		-- 胡萝卜鼠
		CARRAT =
		{
			DEAD = "重归平凡。",		-- 物品名:"胡萝卜鼠"->死了 制造描述:"灵巧机敏，富含胡萝卜素。"
			GENERIC = "奇特的生物。",		-- 物品名:"胡萝卜鼠"->默认 制造描述:"灵巧机敏，富含胡萝卜素。"
			HELD = "我能拿他做什么？",		-- 物品名:"胡萝卜鼠"->拿在手里 制造描述:"灵巧机敏，富含胡萝卜素。"
			SLEEPING = "可爱。",		-- 物品名:"胡萝卜鼠"->睡着了 制造描述:"灵巧机敏，富含胡萝卜素。"
		},

		LIGHTFLIER = "变异的荧光果，除了脆弱以外，也能提供光照。",		-- 物品名:"球状光虫"
		LIGHTCRAB = "闪闪发光。",	-- 物品名:"发光蟹"
    ------ 中立生物-----------------------------------------
	------ 可雇佣中立生物
		-- 皮弗娄牛
		BEEFALO =
		{
			FOLLOWER = "他在静静地跟着我。",		-- 物品名:"皮弗娄牛"->随从
			GENERIC = "一只丰蹄，这里的人叫它皮弗娄牛。",		-- 物品名:"皮弗娄牛"->默认
			NAKED = "看来他很伤心。",		-- 物品名:"皮弗娄牛"->牛毛被刮干净了
			SLEEPING = "祝好梦，大块头的丰蹄先生。",		-- 物品名:"皮弗娄牛"->睡着了
			--Domesticated states:
			DOMESTICATED = "你好啊，小家伙。",		-- 物品名:"皮弗娄牛"->驯化牛
			ORNERY = "它很好斗。",		-- 物品名:"皮弗娄牛"->战斗牛
			RIDER = "更快的速度。",		-- 物品名:"皮弗娄牛"->骑行牛
			PUDGY = "贪吃的小家伙。",		-- 物品名:"皮弗娄牛"->肥牛
			MYPARTNER = "我们永远都是朋友。",		-- 物品名:"皮弗娄牛"->驯好的牛
			DEAD = "希望它的伙伴足够坚强。", 	-- 物品名:"皮弗娄牛"->死亡
			DEAD_MYPARTNER = "梦里潇湘身是客，终会再见。", 	-- 物品名:"皮弗娄牛"->自己的牛死亡
		},
		BEEFALOWOOL = "有丰蹄要掉眼泪了。",		-- 物品名:"牛毛"
		HORN = "梦回，吹角连营。",		-- 物品名:"牛角"
		POOP = "味道真不好闻。",		-- 物品名:"粪肥"
		-- 小皮弗娄牛
		BABYBEEFALO =
		{
			GENERIC = "可爱的小丰蹄。",		-- 物品名:"小皮弗娄牛"->默认
			SLEEPING = "做个好梦。",		-- 物品名:"小皮弗娄牛"->睡着了
		},
			-- 猪人
		PIGMAN =
		{
			DEAD = "至少你留下了你的遗产。",		-- 物品名:"猪人"->死了
			FOLLOWER = "随我走吧，随我去往，永恒的梦境。",		-- 物品名:"猪人"->随从
			GENERIC = "要吃点什么吗？",		-- 物品名:"猪人"->默认
			GUARD = "国王的近卫，忠诚，可靠，难缠。",		-- 物品名:"猪人"->猪人守卫
			WEREPIG = "不是友好的猪！！",		-- 物品名:"猪人"->疯猪
		},
		PIGTENT = "......",		-- 物品名:"猪人帐篷"
		PIGSKIN = "猪猪的皮，有多种用途，只是靠近尾巴这部分…",		-- 物品名:"猪皮"
		-- 猪屋		
		PIGHOUSE =
		{
			FULL = "你在里面研究如何制作超级棒棒糖吗？",		-- 物品名:"猪屋"->满了 制造描述:"可以住一只猪。"
			GENERIC = "有点不稳固，并不适合我。",		-- 物品名:"猪屋"->默认 制造描述:"可以住一只猪。"
			LIGHTSOUT = "诶呀，这么害羞吗。",		-- 物品名:"猪屋"->关灯了 制造描述:"可以住一只猪。"
			BURNT = "看起来猪人在规划的时候没有考虑到火灾。",		-- 物品名:"猪屋"->烧焦的 制造描述:"可以住一只猪。"
		},
		-- 兔人
		BUNNYMAN = "盯着这些卡特斯的眼睛会令人抓狂，小心些。",		-- 物品名:"兔人"
		MANRABBIT_TAIL = "卡特斯的绒毛，那些丰蹄的毛应该更保暖吧。",		-- 物品名:"兔绒"
		-- 兔屋
		RABBITHOUSE =
		{
			GENERIC = "巨大的胡萝卜屋子，一看就知道是卡特斯的房子。",		-- 物品名:"兔屋"->默认 制造描述:"可容纳一只巨大的兔子及其所有物品。"
			BURNT = "诶，变烤胡萝卜了。",		-- 物品名:"兔屋"->烧焦的 制造描述:"可容纳一只巨大的兔子及其所有物品。"
		},
		-- 浣猫
		CATCOON = "你好啊，可爱的菲林。",		-- 物品名:"浣猫"
		COONTAIL = "我觉得它还在摆动。",		-- 物品名:"猫尾"
		-- 空心树桩
		CATCOONDEN =
		{
			GENERIC = "树桩里的窝，或许会有东西。",		-- 物品名:"空心树桩"->默认
			EMPTY = "它的主人似乎不在了，很久不打理这个窝了。",		-- 物品名:"空心树桩"->塌陷
		},
		-- 石虾
		ROCKY = "徒有蛮力而无智。",		-- 物品名:"石虾"
		-- 一角鲸
		GNARWAIL =
		{
			GENERIC = "很大的角。",		-- 物品名:"一角鲸"->默认
			BROKENHORN = "你应得的。",		-- 物品名:"一角鲸"->角断了
			FOLLOWER = "你想和我们一起吗？",		-- 物品名:"一角鲸"->随从
			BROKENHORN_FOLLOWER = "你应该学到了教训。",		-- 物品名:"一角鲸"->断角的随从
		},
		GNARWAIL_HORN = "不可思议！",		-- 物品名:"一角鲸的角"
	------ 不可雇佣中立生物
		-- 考拉象
		KOALEFANT_SUMMER = "移动的肉仓。",		-- 物品名:"考拉象"
		KOALEFANT_WINTER = "他有他自己的冬衣。",		-- 物品名:"考拉象"
		KOALEFANT_CARCASS = "偷猎者应当被制裁。",	-- 物品名:"考拉象尸体"
		-- 水獭掠夺者
		OTTER = "我这里可没有你想要的，还是说你想同我饮一坛？",	--物品名:"水獭掠夺者"
		OTTERDEN = {
			GENERIC = "他们似乎还没有搜刮到东西。",	--物品名:"水獭掠夺者窝点"->默认
			HAS_LOOT = "这些小掠夺者都藏了些什么？",	--物品名:"水獭掠夺者窝点"->有物品
		},
		OTTERDEN_DEAD = "弃船。",	--物品名:"拆毁的水獭掠夺者窝点"
		--  电羊/伏特羊
		LIGHTNINGGOAT =
		{
			GENERIC = "这里的卡普里尼也精通魔法吗？",		-- 物品名:"伏特羊"->默认
			CHARGED = "或许不该让它带电。",		-- 物品名:"伏特羊"->充能
		},
		LIGHTNINGGOATHORN = "他自己的角就是一个引雷针。",		-- 物品名:"伏特羊角"
		GOATMILK = "喝了会不会让我的头发飘起来？",		-- 物品名:"带电的羊奶"
		-- 无眼鹿
		DEER =
		{
			GENERIC = "眼盲心不盲，我能感觉到它在“注视”我。",		-- 物品名:"无眼鹿"->默认
			ANTLER = "有兴趣逐鹿中原吗？",		-- 物品名:"无眼鹿"->有角
		},
		DEER_ANTLER = "明年它的角也许会长出来。",		-- 物品名:"鹿角"
		-- 沙拉蝾螈
		FRUITDRAGON =
		{
			GENERIC = "挺可爱的。",		-- 物品名:"沙拉蝾螈"->默认
			RIPE = "火热的心。",		-- 物品名:"沙拉蝾螈"->在反应中的温泉旁被烤红
			SLEEPING = "在打盹呢。",		-- 物品名:"沙拉蝾螈"->睡着了
		},
		-- 尘蛾
		DUSTMOTH = "没有自由的小家伙，日复一日的维护着这个地方。",		-- 物品名:"尘蛾"	
		DUSTMOTHDEN = "铥矿的来源。",		-- 物品名:"整洁洞穴"
		
		PENGUIN = "披羽生翼，不思碧落，独浩瀚海。",		-- 物品名:"企鸥"
		PERD = "诶诶，留点浆果啊。",		-- 物品名:"火鸡"
		SQUID = "美丽的生物，不知道它的墨汁质量如何。",		-- 物品名:"鱿鱼"
		GRASSGATOR = "它不想与我有太多交集。",		-- 物品名:"草鳄鱼"
	------ 中立特殊NPC
		-- 兔王
		RABBITKING_LUCKY = "带有机缘的兔子。",	--物品名:"机缘兔子"
		RABBITKING_PASSIVE = "你好啊，卡特斯之王。",	--物品名:"和善兔王"
		-- 兔王交易
		RABBITHAT = "友善的象征。",	--物品名:"洞穴花环" 制造描述:"从未如此悠闲的抓过兔子。"
		ARMOR_CARROTLURE = "胡萝卜象征着友谊。",	--物品名:"胡萝卜外套" 制造描述:"穿上这件外套，兔人就会跳过来。"
		RABBITKINGHORN = "召唤小兔子来帮忙。",	--物品名:"挖洞兔号角" 制造描述:"随时随洞召唤兔子来保管你的东西。"
		RABBITKINGHORN_CHEST = "完美的箱子。",	--物品名:"便携式巢穴"
		-- 兔王boss
		RABBITKINGMINION_BUNNYMAN = "兔王的禁卫。",	--物品名:"皇家兔子警卫"
		RABBITKING_AGGRESSIVE = "看起来它黑化了。",	--物品名:"暴戾兔王"
		RABBITKINGSPEAR = "对兔子有们特别有效。",	--物品名:"兔王棍"
		--  流浪商人
        WANDERINGTRADER =
        {
            REVEALED = "希望你今天带了有用的东西。",    --  交易
            GENERIC = "嗯……实用主义的衣品。", --  非交易
        },
	------ 敌对生物-----------------------------------------
		-- 蜘蛛
		SPIDER =
		{
			DEAD = "看来它没法再哈气了。",		-- 物品名:"蜘蛛"->死了
			GENERIC = "这么大的蜘蛛，能捕食多大的昆虫？",		-- 物品名:"蜘蛛"->默认
			SLEEPING = "慢慢睡吧，恕不奉陪。",		-- 物品名:"蜘蛛"->睡着了
		},
        -- 蜘蛛战士
		SPIDER_WARRIOR =
		{
			DEAD = "战士应当视死如归。",		-- 物品名:"蜘蛛战士"->死了
			GENERIC = "精锐的战士，难缠。",		-- 物品名:"蜘蛛战士"->默认
			SLEEPING = "睡着后倒是有办法对付他。",		-- 物品名:"蜘蛛战士"->睡着了
		},
		SPIDER_HEALER = "她会治愈蜘蛛。",		-- 物品名:"护士蜘蛛"
		-- 蜘蛛掉落物
		SILK = "坚韧，光滑，耐用。",		-- 物品名:"蜘蛛丝"
		SPIDERGLAND = "一种特殊的“药”,方或许会感兴趣。",		-- 物品名:"蜘蛛腺"
		-- 普通蜘蛛巢
		SPIDERDEN = "看着挺大。",		-- 物品名:"蜘蛛巢"
		SPIDEREGGSACK = "为什么要留着它呢？斩草当除根。",		-- 物品名:"蜘蛛卵" 制造描述:"跟你的朋友寻求点帮助。"
		-- 蜘蛛女王
		SPIDERQUEEN = "巨大的蜘蛛母体。",		-- 物品名:"蜘蛛女王"
		SPIDERHAT = "戴上它可以用蜘女王的身份对蜘蛛下达命令。",		-- 物品名:"蜘蛛帽" 制造描述:"蜘蛛们会喊你\"妈妈\"。"
		-- 海黾
		SPIDER_WATER = "这里也有蜘蛛。",		-- 物品名:"海黾"
		MUTATOR_WATER = "怪物曲奇饼，让韦伯的蜘蛛朋友变成海黾。",		-- 物品名:"海黾变身涂鸦" 制造描述:"光是看就让人流口水！"
		OCEANVINE_COCOON = "最好摧毁它。",		-- 物品名:"海黾巢穴"
		OCEANVINE_COCOON_BURNT = "燃爆了。",		-- 物品名:"海黾巢穴"->烧焦了
		-- 悬蛛
		SPIDER_DROPPER = "不-要-抬-头。",		-- 穴居悬蛛
		DROPPERWEB = "这是个陷阱！",         -- 穴居悬蛛网
		-- 洞穴蜘蛛
		SPIDER_HIDER = "它们在头顶！",		-- 物品名:"洞穴蜘蛛"
		SPIDER_SPITTER = "我讨厌蜘蛛！",		-- 物品名:"喷射蜘蛛"
		SPIDERHOLE = "蜘蛛结网生尘埃。",		-- 物品名:"蛛网岩"
		SPIDERHOLE_ROCK = "蜘蛛结网生尘埃。",		-- 物品名:"蛛网岩"
		-- 破碎蜘蛛
		SPIDER_MOON =
		{
			GENERIC = "变异的蜘蛛，有些难缠。",		-- 物品名:"破碎蜘蛛"->默认
			SLEEPING = "变成这样，你会梦到什么呢？",		-- 物品名:"破碎蜘蛛"->睡着了
			DEAD = "至少你可以安息了。",		-- 物品名:"破碎蜘蛛"->死了
		},
		MOONSPIDERDEN = "它们用石头搭建了一座巢穴。",		-- 物品名:"破碎蜘蛛洞"

    	-- 青蛙
		FROG =
		{
			DEAD = "我可不是娇弱的蝴蝶。",		-- 物品名:"青蛙"->死了
			GENERIC = "独坐池塘如虎踞，绿荫树下养精神。春来我不先开口，哪个虫儿敢作声？",		-- 物品名:"青蛙"->默认
			SLEEPING = "在梦里你会追逐多大的虫儿呢？",		-- 物品名:"青蛙"->睡着了
		},
		-- 青蛙掉落物
		FROGLEGS = "只吃蛙腿有点奢侈了，在江南，田鸡有各种各样的做法。",		-- 物品名:"蛙腿"
		FROGLEGS_COOKED = "鸡肉味，嘎嘣脆。",		-- 物品名:"烤蛙腿"
		-- 青蛙巢穴
		POND = "不向横塘泥里栽，可惜，这里只有鱼和田鸡，没有荷。",		-- 物品名:"池塘"
		MARSH_PLANT = "傍水而生。",		-- 物品名:"植物"->池塘边缘的植物
		-- 月后青蛙
		LUNARFROG = "在接受的月裔的视界后，它们变得“炯炯有神”。",	-- 物品名:"明眼青蛙"
	
		-- 猎犬
		HOUND = "从小就被灌输命令与服从的家伙。",		-- 物品名:"猎犬"
		FIREHOUND = "火焰裹挟着它，也许它他体内有火焰的结晶。",		-- 物品名:"红色猎犬"
		ICEHOUND = "看他的外表就知道它体内有冰霜的力量。",		-- 物品名:"蓝色猎犬"
		-- 猎犬掉落物
		HOUNDSTOOTH = "走狗的尖牙。",		-- 物品名:"犬牙"
		-- 猎犬巢穴
		HOUNDBONE = "看来它们世代生活在荒漠。",		-- 物品名:"犬骨"
		HOUNDMOUND = "骨头堆砌的，是家园，还是坟墓？",		-- 物品名:"猎犬丘"
		-- 猎犬转变过程
		HOUNDCORPSE =
		{
			GENERIC = "和它的先辈一样，尘归尘，土归土。",		-- 物品名:"猎犬"->默认
			BURNING = "让火焰净化一切。",		-- 物品名:"猎犬"->正在燃烧
			REVIVING = "高天上的月裔，也喜欢摆弄尸体吗？",		-- 物品名:"猎犬"->复活为恐怖猎犬
		},
		-- 恐怖猎犬
		MUTATEDHOUND =
		{
			DEAD = "结束了。",		-- 物品名:"恐怖猎犬"->死了
			GENERIC = "卑劣的实验。",		-- 物品名:"恐怖猎犬"->默认
			SLEEPING = "变成这样了还会做梦吗。",		-- 物品名:"恐怖猎犬"->睡着了
		},
		-- 座狼
		WARG = "你就是头狼了？",		-- 物品名:"座狼"
		WARGLET = "看来你的号召力还不够强。",	--物品名:"青年座狼"
		MUTATEDWARG = "即使死去，他依旧是头狼。",	-- 物品名:"附身座狼"
		-- 座狼尸体
		WARGCORPSE =
		{
			GENERIC  = "不对劲。",	-- 物品名:"座狼"->尸体
			BURNING  = "也许“装死”骗我。",	-- 物品名:"座狼"->尸体燃烧
			REVIVING = "这些月裔还真是无孔不入。",	-- 物品名:"座狼"->尸体复活
		},

		-- 发条生物
		BISHOP = "一具傀儡，背后肯定有谋算者!",		-- 物品名:"发条主教"
		BISHOP_CHARGE_HIT = "诶呦，电麻了。",		-- 物品名:"发条主教光球"->被主教攻击
		ROOK = "你不能歇一歇吗。",		-- 物品名:"发条战车"
		KNIGHT = "你可不是真正的骑士。",		-- 物品名:"发条骑士"
		-- 发条掉落物
		GEARS = "一堆机械零件，有所磨损但还能用。",		-- 物品名:"齿轮"
		
		-- 蜜蜂		
		BEE =
		{
			GENERIC = "采得百花成蜜后，为谁辛苦为谁甜。",		-- 物品名:"蜜蜂"->默认
			HELD = "秋成想见香租人，菊露风胶蜜几脾。",		-- 物品名:"蜜蜂"->拿在手里
		},
		BEEHIVE = "天然的蜂窝，蜜蜂们忙个不停。",		-- 物品名:"蜂窝"
		-- 杀人蜂
		KILLERBEE =
		{
			GENERIC = "这么大的蜜蜂，被蜇到肯定青一块紫一块。",		-- 物品名:"杀人蜂"->默认
			HELD = "千万不能让它逃走，不然就遭老罪了。",		-- 物品名:"杀人蜂"->拿在手里
		},
		WASPHIVE = "最好别靠近它们。",		-- 物品名:"杀人蜂蜂窝"
		-- 蜜蜂相关掉落物	
		STINGER = "它的刺并没有连接脏器。",		-- 物品名:"蜂刺"
		HONEY = "甘甜且美味，乌萨斯的最爱。",		-- 物品名:"蜂蜜"
		HONEYCOMB = "用来建造蜂箱……或者下锅。",-- 蜜脾

		-- 坎普斯
		KRAMPUS = "“自诩正义”的窃贼。",		-- 物品名:"坎普斯"
		KRAMPUS_SACK = "现在谁才是掠夺者？",		-- 物品名:"坎普斯背包"
		-- 树精
		LEIF = "森林做出了反击。",		-- 物品名:"树精守卫"->常青树
		LEIF_SPARSE = "似乎只是看起来更粗壮而已。",		-- 物品名:"树精守卫"->粗壮常青树
		-- 钢羊
		SPAT = "她的羊毛可不好薅啊。",		-- 物品名:"钢羊"
		PHLEGM = "我不知道该用它做什么。",		-- 物品名:"脓鼻涕"
		STEELWOOL = "一团乱糟糟的金属丝。",		-- 物品名:"钢丝绵"
		-- 猪人守卫
		PIGGUARD = "更强大的猪人战士。",		-- 物品名:"猪人守卫"
		PIGTORCH = "信仰的图腾。",		-- 物品名:"猪火炬"
		-- 海象
		WALRUS = "你需要食物，巧了，我也是。",		-- 物品名:"海象"
		LITTLE_WALRUS = "父债应子偿。",		-- 物品名:"小海象"
		WALRUSHAT = "某种制式的帽子。",		-- 物品名:"贝雷帽"
		WALRUS_TUSK = "被狩猎的猎人。",		-- 物品名:"海象牙"
		-- 海象营地
		WALRUS_CAMP =
		{
			EMPTY = "一个营地，已经撤走了。",		-- 物品名:"海象营地"->非冬季时没有房子
			GENERIC = "萨米的风格。",		-- 物品名:"海象营地"->默认
		},
		
		-- 蚊子
		MOSQUITO =
		{
			GENERIC = "幸好不是机械的。",		-- 物品名:"蚊子"->默认
			HELD = "夏天最烦人的生物。",		-- 物品名:"蚊子"->拿在手里
		},
		MOSQUITOSACK = "那位罗德岛的医生会喜欢这个的。",		-- 物品名:"蚊子血囊"
		POND_MOS = "满是蚊虫，可惜没有青蛙。",-- 沼泽池塘

		-- 鱼人
		MERM = "满身腥味。",		-- 物品名:"鱼人"
		MERMHOUSE =
		{
			GENERIC = "这个房子的设计水平太差了。",		-- 物品名:"漏雨的小屋"->默认
			BURNT = "现在更破旧了。",		-- 物品名:"漏雨的小屋"->烧焦的
		},
		-- 猴子
		-- 穴居猴
		MONKEY = "总感觉他们不是很友善。",		-- 物品名:"穴居猴"
		MONKEYBARREL = "一眼就能看出来是谁的家。",		-- 物品名:"穴居猴桶"
		-- 海盗猴
		POWDER_MONKEY = "讨厌的猴子。",	-- 物品名:"火药猴"
		PRIME_MATE = "看起来他就是头。",	-- 物品名:"大副"
		-- 海盗猴物品
		CURSED_MONKEY_TOKEN = "毁灭的象征。",	-- 物品名:"诅咒饰品"
		CUTLESS = "这些猴子的武器可以从敌人身上打落东西。",	-- 物品名:"木头短剑"
		OAR_MONKEY = "除了划船也可以战斗。",	-- 物品名:"战桨"
		MONKEY_MEDIUMHAT = "杨帆，启航。",	-- 物品名:"船长的三角帽"
		MONKEY_SMALLHAT = "看起来像是海盗。",	-- 物品名:"海盗头巾"
		-- 海盗战利品
		PIRATE_STASH = "很贴心的标记。",	-- 物品名:"X"
		STASH_MAP = "通向海盗的销赃地点的地图。",	-- 物品名:"海盗地图"
		-- 猴子小屋
		MONKEYHUT =
		{
			GENERIC = "海盗猴的小房子。",	-- 物品名:"猴子小屋"->默认
			BURNT = "看来他们没有做好消防演练。",	-- 物品名:"猴子小屋"->烧毁
		},
		-- 蛞蝓龟	
		SLURTLE = "呕...恶心...",		-- 物品名:"蛞蝓龟"
		SNURTLE = "可悲，真正的蜗牛反倒成了另类。",		-- 物品名:"蜗牛龟"

		SLURTLE_SHELLPIECES = "看来没法再拼在一起了。",		-- 物品名:"壳碎片"
		SLURTLEHAT = "内侧还黏糊糊的。",		-- 物品名:"背壳头盔"
		ARMORSNURTLESHELL = "很黏，但是防护性很好。",		-- 物品名:"蜗壳护甲"
		SLURTLESLIME = "蛞蝓在吞食硝石后留下的粘液会剧烈爆炸。",		-- 物品名:"蛞蝓龟黏液"
		
		SLURTLEHOLE = "蛞蝓巢穴。",		-- 物品名:"蛞蝓龟窝"

		-- 啜食者
		SLURPER = "好多毛。",		-- 物品名:"啜食者"
		SLURPER_PELT = "还是好多毛。",		-- 物品名:"啜食者皮"
		-- 洞穴蝙蝠
		BAT = "或许我不该招惹他们",		-- 物品名:"洞穴蝙蝠"
		BATCAVE = "还是离远些吧。",		-- 物品名:"蝙蝠洞"
		-- 裸鼹蝠
		MOLEBAT = "它似乎更喜欢在地面以下。",		-- 物品名:"裸鼹鼠蝙蝠"
		MOLEBATHILL = "它在休息。",		-- 物品名:"裸鼹鼠蝙蝠山丘"
		-- 高脚鸟
		TALLBIRD = "多少人做梦都想拥有这么长的腿呢？",		-- 物品名:"高脚鸟"
		-- 高脚鸟巢
		TALLBIRDNEST =
		{
			GENERIC = "偷走他需要冒很大风险。",		-- 物品名:"高脚鸟巢"->默认
			PICKED = "也许它会再次下蛋呢？",		-- 物品名:"高脚鸟巢"->被采完了
		},
		-- 果蝇
		FRUITFLY = "秽种窃膏雨，振翅播芜丛。",		-- 物品名:"果蝇"
		LORDFRUITFLY = "别多话！你再吵！滚出去！",		-- 物品名:"果蝇王"
		-- 触手
		TENTACLE = "最好离它远点吧。",		-- 物品名:"触手"
		TENTACLESPIKE = "看起来还能用",		-- 物品名:"触手尖刺"
		TENTACLESPOTS = "奇特的繁殖方式。",		-- 物品名:"触手皮"
		-- 月岩企鸥
		MUTATED_PENGUIN =
		{
			DEAD = "结束了…",		-- 物品名:"月岩企鸥"->死了
			GENERIC = "看起来只是行尸走肉。",		-- 物品名:"月岩企鸥"->默认
			SLEEPING = "睡着的只是里面的月裔。",		-- 物品名:"月岩企鸥"->睡着了
		},
		-- 远古哨兵
		ARCHIVE_CENTIPEDE = "你的文明已经抛弃了这里，你的坚持还有什么意义？",		-- 物品名:"远古哨兵蜈蚣"
		ARCHIVE_CENTIPEDE_HUSK = "一堆损坏的零件，似乎在自行修复。",		-- 物品名:"哨兵蜈蚣壳"
		-- 虚影
		GESTALT = "月裔的投影。",		-- 物品名:"虚影"
		GESTALT_GUARD = "它在与暗影争斗，以守护这里。",		-- 物品名:"大虚影"
		-- 饼干切割机
		COOKIECUTTER = "它对我的船虎视眈眈。",		-- 物品名:"饼干切割机"
		COOKIECUTTERSHELL = "不知道哪里会用到这个。",		-- 物品名:"饼干切割机壳"

		GHOST = "真可怜，死后也不得安宁。",		-- 物品名:"幽灵"
		SHARK = "麻烦的家伙，浑身是石头的它怎么还能游动这么快呢。",		-- 物品名:"岩石大白鲨"
		BUZZARD = "在一场场战争过后哦，总能看见大量的秃鹫。",		-- 物品名:"秃鹫"
    ------ BOSS相关
		-- 麋鹿鹅
		MOOSE_NESTING_GROUND = "巨大的巢穴，它应该就在附近。",		-- 物品名:"麋鹿鹅巢"

		MOOSE = "长着鹿角的鹅，山海众的文献里也没有它的记录。",		-- 物品名:"麋鹿鹅"
		MOOSEEGG = "你也会“五雷正法”吗？",		-- 物品名:"麋鹿鹅蛋"
		MOSSLING = "看起来很可爱。",		-- 物品名:"麋鹿鹅幼崽"
		
		GOOSE_FEATHER = "蔷薇藤老开花浅,翡翠巢空落羽奇。",		-- 物品名:"麋鹿鹅羽毛"
		-- 蚁狮
		ANTLION =
		{
			GENERIC = "我身上有它想要的东西。",		-- 物品名:"蚁狮"->默认
			VERYHAPPY = "看来他心情不错。",		-- 物品名:"蚁狮"->经过交易后耐心较高
			UNHAPPY = "看来他很急躁。",		-- 物品名:"蚁狮"->长时间不交易耐心较低
		},	
		-- 蚁狮部分掉落
		ANTLIONTRINKET = "有个家伙可能对此感兴趣。",		-- 物品名:"沙滩玩具"
		COTL_TRINKET = "诡异的王冠。",	-- 物品名:"红冠"
		-- 蚁狮技能召唤
		SANDSPIKE = "灰色的林也会这招。",		-- 物品名:"沙刺"
		SANDBLOCK = "聚沙成塔。",		-- 物品名:"沙堡"
		GLASSSPIKE = "让我想起了那位林家小姐。",		-- 物品名:"玻璃尖刺"
		GLASSBLOCK = "烈火烧灼后的晶莹城堡。",		-- 物品名:"玻璃城堡"
		
		-- 龙蝇
		DRAGONFLY = "口吐烈焰的？龙？还是苍蝇？",		-- 物品名:"龙蝇"
		DRAGON_SCALES = "还是热的，或许会很有用。",		-- 物品名:"鳞片"
		-- 龙蝇唾液
		LAVASPIT =
		{
			HOT = "只是滚烫的口水。",		-- 物品名:"龙蝇唾液"->灼热
			COOL = "或许该叫它“龙蝇龙涎”？",		-- 物品名:"龙蝇唾液"->冷却
		},
		-- 岩浆池
		LAVA_POND = "如果没有那只大苍蝇，这里可以适合建造一个铁匠铺。",		-- 物品名:"岩浆池"
		LAVA_POND_ROCK = "年可能会更喜欢这里。",		-- 物品名:"岩石"（岩浆池边缘的石头）
		LAVAE = "龙蝇的子嗣，看来他的确是苍蝇。",		-- 物品名:"岩浆虫"

		-- 熊獾
		BEARGER = "熊一样大的獾。",		-- 物品名:"熊獾"
		MUTATEDBEARGER = "那些尖锐的玻璃让它更难缠了。",	-- 物品名:"装甲熊獾"
		-- 熊獾尸体
		BEARGERCORPSE =
		{
			GENERIC  = "有问题…",	-- 物品名:"熊獾"->尸体
			BURNING  = "也许是“装死”骗我。",	-- 物品名:"熊獾"->尸体燃烧
			REVIVING = "这些月裔还真是无孔不入。",	-- 物品名:"熊獾"->尸体复活
		},
		FURTUFT = "积少成多，也许能做出一张完整的熊皮。",		-- 物品名:"毛丛"
		BEARGER_FUR = "一块厚毛皮。",		-- 物品名:"熊皮" 制造描述:"毛皮再生。"

		-- 独眼巨鹿
		DEERCLOPS = "那只眼睛真大，除此之外它的法术也比较难搞。",		-- 物品名:"独眼巨鹿"
		MUTATEDDEERCLOPS = "被月裔改造后更难缠了。",	-- 物品名:"晶体独眼巨鹿"
		-- 独眼巨鹿尸体
		DEERCLOPSCORPSE =
		{
			GENERIC  = "总算结束了。",	-- 物品名:"独眼巨鹿"->尸体
			BURNING  = "也许是“装死”骗我。",	-- 物品名:"独眼巨鹿"->尸体燃烧
			REVIVING = "这些月裔还真是无孔不入。",	-- 物品名:"独眼巨鹿"->尸体复活
		},
		DEERCLOPS_EYEBALL = "现在你再怎么瞪我，你也拿我无能为力了。",		-- 物品名:"独眼巨鹿眼球"

		-- 颗粒状传输/瓦格斯塔夫投影(NPC)
		WAGSTAFF_NPC = "你在研究月亮的力量，这是个危险的举动。",		-- 月亮风暴中
		WAGSTAFF_NPC_MUTATIONS = "你想要我帮你猎杀那些变异生物？",		-- 击败天体英雄后
		WAGSTAFF_NPC_WAGPUNK = "他似乎在某一关键的环节出现了瓶颈。",	 -- 研究月后三王尸体、给予火花柜
		-- 瓦格斯塔夫投影工具
		WAGSTAFF_TOOL_1 = "奇特的装置，他需要的应该就是这个。",		-- 物品名:"网状缓冲器"
		WAGSTAFF_TOOL_2 = "奇特的装置，他需要的应该就是这个。",		-- 物品名:"装置除垢器"
		WAGSTAFF_TOOL_3 = "奇特的装置，他需要的应该就是这个。",		-- 物品名:"垫圈开槽器"
		WAGSTAFF_TOOL_4 = "奇特的装置，他需要的应该就是这个。",		-- 物品名:"概念刷洗器"
		WAGSTAFF_TOOL_5 = "奇特的装置，他需要的应该就是这个。",		-- 物品名:"校准观察机"

		WAGSTAFF_MACHINERY = "他遗留下的工作台也许能找到什么有用的东西。",	-- 物品名:"被丢弃的垃圾"
		WAGSTAFF_MUTATIONS_NOTE = "他的想法很大胆，而又鲁莽，亦或者他有别的谋划。",	-- 物品名:"研究笔记"
		MOON_ALTAR_LINK = "一股强大的能量，似乎和高天上的月亮息息相关。",		-- 物品名:"神秘能量"

		-- 月亮虹吸器/未完成的实验
		MOON_DEVICE = {
			GENERIC = "不太对劲。",		-- 物品名:"月亮虹吸器"->默认
			CONSTRUCTION1 = "看起来还缺少什么。",		-- 物品名:"月亮虹吸器"->建造一阶段
			CONSTRUCTION2 = "完成了，不过我感觉有东西在盯着这里。",		-- 物品名:"月亮虹吸器"->建造二阶段
		},
		ALTERGUARDIAN_CONTAINED = "这个装置能抽取月亮的力量。",		-- 物品名:"月亮精华提取器"
		-- 天体英雄(一阶段)
		ALTERGUARDIAN_PHASE1 = {
			GENERIC = "自月亮落下的天体英雄。",		-- 一阶段检查
			DEAD = "它的外壳碎裂了一部分。",		 -- 转阶段中
		},
		-- 天体英雄(二阶段)
		ALTERGUARDIAN_PHASE2 = {
			GENERIC = "它在使用祭坛的力量进行战斗。",		-- 二阶段检查
			DEAD = "还没有结束。",						-- 转阶段中
		},
		-- 天体英雄(三阶段)
		ALTERGUARDIAN_PHASE3 = "终于露出真容了吗？",		-- 三阶段检查
		ALTERGUARDIAN_PHASE3DEADORB = "不确定有没有彻底结束。",		-- 死亡时天体英雄
		ALTERGUARDIAN_PHASE3DEAD = "它的能量已经被收走了。",		-- 被击败的天体英雄
		-- 天体英雄召唤物
		ALTERGUARDIAN_PHASE2SPIKE = "避开那些障碍。",		-- 物品名:"月光玻璃尖刺"
		ALTERGUARDIAN_PHASE3TRAP = "得小心它的视界。",		-- 物品名:"启迪陷阱"
		-- 天体英雄掉落物
		ALTERGUARDIANHAT = "祂的视界比我想象的要广阔。",		-- 物品名:"启迪之冠"
		ALTERGUARDIANHATSHARD = "即使是碎片也储存了不少能量。",		-- 物品名:"启迪之冠碎片"

		-- 大霜鲨
		SHARKBOI = "看起来它很迷茫。",	--物品名:"大霜鲨"
		BOOTLEG = "独特的洋流操纵能力。",	--物品名:"出逃腿靴"
		OCEANWHIRLPORTAL = "海流会把船送到目的地。",	--物品名:"漩涡传送门"

		-- 远古守护者(犀牛)
		MINOTAUR = "或许我该拿一块红色的布？。",		-- 物品名:"远古守护者"
		MINOTAURCHEST = "更大的箱子，会有什么好东西呢？",		-- 物品名:"大号华丽箱子"
		MINOTAURHORN = "稀奇的东西，易会喜欢它的。",		-- 物品名:"守护者之角"
		ATRIUM_KEY = "这是从它里面发射出来的能量。",		-- 物品名:"远古钥匙"

		-- 盒中泰拉
		TERRARIUM = {
			GENERIC = "连同着一方小天地。",		-- 默认
			CRIMSON = "噩梦会腐化这片小天地。",		-- 给予噩梦燃料
			ENABLED = "有什么东西在看着我。",		-- 激活
			WAITING_FOR_DARK = "白天它不会出来。",		-- 等待夜晚
			COOLDOWN = "得等待一段时间。",		-- 冷却中
			SPAWN_DISABLED = "通路被阻断了。",		-- 无法召唤
		},
		-- 显眼的箱子
		TERRARIUMCHEST = 
		{
			GENERIC = "显眼的陷阱，不过里面的东西值得冒险。",		-- 默认
			BURNT = "结束了。",		-- 烧焦的
			SHIMMER = "太显眼了吧。",		--没人动过
		},
		-- 单眼boss
		EYEOFTERROR = "异世界的窥伺者。",		-- 物品名:"恐怖之眼"
		EYEOFTERROR_MINI = "更多的窥伺者。",		-- 物品名:"嫌疑窥视者"
		EYEOFTERROR_MINI_GROUNDED = "最好先解决它。",		-- 物品名:"恐怖之蛋"
		-- 掉落物
		EYEMASKHAT = "“独具慧眼”。",		-- 物品名:"眼面具"
		MILKYWHITES = "我不想过多评价…",		-- 物品名:"乳白物"
		-- 双眼boss
		TWINOFTERROR1 = "电眼逼人。",		-- 物品名:"激光眼"
		TWINOFTERROR2 = "目光灼灼。",		-- 物品名:"魔焰眼"
		-- 双眼独特掉落物
		SHIELDOFTERROR ="克苏鲁之盾",		-- 物品名:"恐怖盾牌"

		-- 克劳斯
		DEER_GEMMED = "那只强盗野兽控制控制着它。",		-- 物品名:"无眼鹿"->克劳斯身边的宝石鹿

		KLAUS = "行侠仗义？怕只是杀人放火的借口。",		-- 物品名:"克劳斯"
		KLAUSSACKKEY = "看着挺不错。",		-- 物品名:"麋鹿茸"
		KLAUS_SACK = "全是赃物。",		-- 物品名:"赃物袋"

		-- 邪天翁
		MALBATROSS = "离我的鱼远些。",		-- 物品名:"邪天翁"
		MALBATROSS_FEATHER = "你应得的教训。",		-- 物品名:"邪天翁羽毛"
		MALBATROSS_BEAK = "就当你的补偿了。",		-- 物品名:"邪天翁喙"

        -- 帝王蟹
		CRABKING =
		{
			GENERIC = "月裔的诅咒让你失了智。",		-- 物品名:"帝王蟹"->默认
			INERT = "一座巨大的城堡。",		-- 物品名:"帝王蟹"->未唤醒
		},
		-- 召唤物
		CRABKING_CLAW = "巨大的钳子，他的帮手来了。",			-- 巨钳
		CRABKING_CANNONTOWER = "看来这位国王有重火力支援。",	-- 加农炮塔
		CRABKING_MOB = "虽然很小个，但是看起来很凶。",			-- 蟹卫
		CRABKING_MOB_KNIGHT = "螃蟹国王派出了它的精锐骑士。",	-- 蟹骑士
		CRABKING_ICEWALL = "智筑冰城。",						-- 冰障
		-- 独特掉落物
		BOAT_BUMPER_CRABKING = "满满的安全感。",	-- 物品名:"帝王蟹保险杠"
		BOAT_BUMPER_CRABKING_KIT = "顶级的城堡保险杠。",	-- 物品名:"帝王蟹保险杠套装"

		--  蜂后
		BEEQUEENHIVEGROWN = "盛极必衰，但它还是长到这么大了。",		-- 物品名:"巨大蜂窝"
		
		BEEQUEEN = "巨大的蜜蜂女王。",		-- 物品名:"蜂后"
		BEEGUARD = "它正在守卫女王。",		-- 物品名:"嗡嗡蜜蜂"
		-- 蜂蜜地块，巨大蜂窝的蜂王死后的状态
		BEEQUEENHIVE =
		{
			GENERIC = "地面太粘了。",		-- 物品名:"蜂蜜地块"->蜂后被击败
			GROWING = "蜂巢会重新长大。",		-- 物品名:"蜂蜜地块"->正在重新生长
		},
		--  蜂后掉落物
		HIVEHAT = "我与天地周旋久，写尽梦，便成梦。",		-- 物品名:"蜂王冠"
		ROYAL_JELLY = "蜂王的食物，营养丰富。",		-- 物品名:"蜂王浆"
-------- 地下&暗影线&天体线---------------------------------------------------------------------------------
    -------洞穴&远古&远古档案馆&中庭
		-- 洞穴出入口
		CAVE_ENTRANCE = "那块石头底下或许有什么东西？",		-- 物品名:"被堵住的洞穴"
		-- 洞穴人口（前往地下）
	   	CAVE_ENTRANCE_OPEN =
		{
			GENERIC = "洞穴不能从这一侧进入！",		-- 物品名:"洞穴"->封住
			OPEN = "或许能考古出远超现在的技术？",		-- 物品名:"洞穴"->打开
			FULL = "我该等会再下去？",		-- 物品名:"洞穴"->满了
		},
		-- 楼梯(前往地上)
		CAVE_EXIT =
		{
			GENERIC = "得换条路。",		-- 物品名:"楼梯"->封住
			OPEN = "梦醒了，该回去了。",		-- 物品名:"楼梯"->打开
			FULL = "上面太拥挤！",		-- 物品名:"楼梯"->满了
		},

		-- 地下虫洞
		TENTACLE_PILLAR = "它快触及到洞穴天花板了。",		-- 物品名:"大触手"
		TENTACLE_GARDEN = "又一种巨大黏滑的触手。",		-- 物品名:"大触手"
		TENTACLE_PILLAR_ARM = "它的子代？还是说地下的部分？",		-- 物品名:"小触手"
		TENTACLE_PILLAR_HOLE = "不知道通向哪里。",		-- 物品名:"硕大的泥坑"
		-- 发光浆果
		WORMLIGHT = "饱满的浆果，还会发光，看起来很适合酿酒。",		-- 物品名:"发光浆果"
		WORMLIGHT_LESSER = "有一些瘪，但是不影响吃。",		-- 物品名:"小发光浆果"
		WORMLIGHT_PLANT = "我觉得挺安全。",		-- 物品名:"神秘植物"（光莓）
		-- 荧光草
		FLOWER_CAVE = "萤火微光,愿为其芒。",			-- 单
		FLOWER_CAVE_DOUBLE="双宿双生，偕行而终。",	-- 双
		FLOWER_CAVE_TRIPLE="三生为众，难抵长暗。",	-- 三
		LIGHTBULB = "可惜酿出来的酒不会发光。",		-- 物品名:"荧光果"
		
		-- 蘑菇树
        -- 蓝蘑菇树
		MUSHTREE_TALL =
		{
			GENERIC = "蓝色的菌类，在地下长的相当大",		-- 物品名:"蓝蘑菇树"->默认
			BLOOM = "空气中满是孢子。",		-- 物品名:"蓝蘑菇树"->蘑菇树繁殖
			ACIDCOVERED = "沾满了酸液。",	-- 物品名:"蓝蘑菇树"->被酸雨腐蚀
		},
		-- 蛛网蓝蘑菇树
		MUSHTREE_TALL_WEBBED =
		{
			GENERIC = "满是蛛网。",		-- 物品名:"蛛网蓝蘑菇树"->默认
			ACIDCOVERED = "沾满了酸液。",	-- 物品名:"蛛网蓝蘑菇树"->酸雨腐蚀
		},
		-- 红蘑菇树
		MUSHTREE_MEDIUM =
		{
			GENERIC = "鲜艳的红色在表示它的毒性。",		-- 物品名:"红蘑菇树"->默认
			BLOOM = "或许该离远些。",		-- 物品名:"红蘑菇树"->蘑菇树繁殖
			ACIDCOVERED = "沾满了酸液。",	-- 物品名:"红蘑菇树"->被酸雨腐蚀
		},
		-- 绿蘑菇树
		MUSHTREE_SMALL =
		{
			GENERIC = "看着还不错。",		-- 物品名:"绿蘑菇树"->默认
			BLOOM = "它在努力散播孢子。",		-- 物品名:"绿蘑菇树"->蘑菇树繁殖
			ACIDCOVERED = "沾满了酸液。",	-- 物品名:"绿蘑菇树"->被酸雨腐蚀
		},
		-- 蘑菇孢子
        -- 蓝色孢子
		SPORE_TALL =
		{
			GENERIC = "它能当蓝色的光源，可是我该在哪里放置它呢？",		-- 物品名:"蓝色孢子"->默认
			HELD = "一捧微光。",		-- 物品名:"蓝色孢子"->拿在手里
		},
		-- 红色孢子
		SPORE_MEDIUM =
		{
			GENERIC = "它能当红色的光源，可是我该在哪里放置它呢？",		-- 物品名:"红色孢子"->默认
			HELD = "一捧微光。",		-- 物品名:"红色孢子"->拿在手里
		},
		-- 绿色孢子
		SPORE_SMALL =
		{
			GENERIC = "它能当绿色的光源，可是我该在哪里放置它呢？",		-- 物品名:"绿色孢子"->默认
			HELD = "一捧微光。",		-- 物品名:"绿色孢子"->拿在手里
		},

		-- 地下池塘
		 POND_CAVE = "鳗井由来岁月深，泓澄一镜绝尘侵。",  -- 洞穴池塘(鳗鱼池塘)
		POND_ALGAE = "池上碧苔三四点，叶底金雀一两声。 日长飞絮轻。",		-- 物品名:"水藻"（洞穴池塘边缘的水藻）



		-- 巨石枝
		TREE_ROCK =
		{
			BURNING = "承地玄，无以阻离火。", -- 燃烧
			CHOPPED = "虽承巨石，其茎可伐。", -- 砍倒
			GENERIC = "砍倒它需要一点技巧。", -- 普通
		},
		TREE_ROCK_SEED    = "顽强的植物。",     -- 巨石枝种子
		TREE_ROCK_SAPLING = "别它会从地下挖掘出什么？。", -- 巨石枝树苗
		-- 喷气孔
		CAVE_VENT_ROCK =
		{
			GENERIC = "也许能用它建造一座无需燃料的火炉，用来煮酒。", -- 未喷发
			HOT     = "看起来改造成本很大，也许应该让年和易想想办法。", -- 热空气
			GAS     = "小心火烛。", -- 瓦斯气
			MIASMA  = "来自暗影的腐化。", -- 暗影瘴气
		},
		-- 地热区植物
		CAVE_FERN_WITHERED   = "温度太高了。", -- 枯萎的洞穴蕨类
		FLOWER_CAVE_WITHERED = "人走茶凉花独谢。",          -- 枯萎的洞穴花
		-- 热地螨
		CAVE_VENT_MITE =
		{
			DEAD     = "现在这样，也挺好。",     -- 死亡
			GENERIC  = "它们会喝酒吗。", -- 普通
			SLEEPING = "生活在这里的你们，又会梦到什么？", -- 睡觉
			VENTING  = "该离它远点了。", -- 喷发
		},

		-- 钻地蠕虫
		WORM =
		{
			PLANT = "为什么感觉它有点格格不入？",		-- 物品名:"洞穴蠕虫"->伪装成大光莓
			DIRT = "什么时候多了一堆土？",		-- 物品名:"洞穴蠕虫"->潜伏在地下
			WORM = "这是土龙还是爬虫？",		-- 物品名:"洞穴蠕虫"->钻出来了
		},
		WORM_BOSS = "巨大变异的地龙，很难缠。",	--物品名:"巨大洞穴蠕虫"

		-- 损坏的发条装置
		CHESSJUNK1 = "一堆烂发条装置，或许我能修好它。",		-- 物品名:"损坏的发条装置"
		CHESSJUNK2 = "另一堆烂发条装置，或许我能修好它。",		-- 物品名:"损坏的发条装置"
		CHESSJUNK3 = "更多的烂发条装置，或许我能修好它。",		-- 物品名:"损坏的发条装置"
			
		BISHOP_NIGHTMARE = "主教在分崩离析！",		-- 物品名:"损坏的发条主教"
		ROOK_NIGHTMARE = "战车在悲鸣！",		-- 物品名:"损坏的发条战车"
		KNIGHT_NIGHTMARE = "骑士在狞笑！",		-- 物品名:"损坏的发条骑士"
		
		CHEST_MIMIC_REVEALED = "被暗影附身的宝箱，也许能让某些东西“活”过来。",	--物品名:"暴躁箱子"
		
		 -- 梦魇疯猪
		DAYWALKER =
		{
			GENERIC = "农夫与蛇。",	-- 被释放
			IMPRISONED = "他被锁住肯定是有原因的。",	-- 被锁住
		},
		-- 开裂的柱子
		DAYWALKER_PILLAR =
		{
			GENERIC = "里面还包裹着什么。",	-- 未开采
			EXPOSED = "里面是纯粹绝望凝聚的石头。",	-- 已开采
		},
		-- 拾荒疯猪
		DAYWALKER2 =
		{
			GENERIC = "看起来它老实多了。",	-- 中立
			BURIED = "该不该帮他呢？",	-- 被困住
			HOSTILE = "看起来他并没有长记性。",	-- 敌对
		},
		-- 麻刺节点
		FENCE_ELECTRIC =
		{
			LINKED = "小心触电。", -- 已连接
			GENERIC = "电器，轻而易举。", -- 未连接
		},
		FENCE_ELECTRIC_ITEM = "那家伙一堆发明之中少有的实用品。", -- 麻刺节点物品形式
		SCRAP_MONOCLEHAT = "用齿轮组与透镜放大视野。",	--物品名:"地平线扩展器"
		SCRAPHAT = "脑袋怎么尖尖的。",	--物品名:"拾荒尖帽"
	
		-- 骨架相关
		FOSSIL_PIECE = "该怎么拼回去呢？方更擅长这些。",		-- 物品名:"化石碎片"
		-- 骨架
		FOSSIL_STALKER =
		{
			GENERIC = "还有些碎片没找到。",		-- 默认
			FUNNY = "看着就不对。",		-- 错误
			COMPLETE = "死去的生物又该如何复生呢？至少它还留有些真实存在的东西。",		-- 准备好了
		},
		SHADOWHEART = "被魔法簇拥着的心脏，如同它的颜色一般黑暗。",		-- 物品名:"暗影心房"
		-- 生成生物
		STALKER = "暗影的力量操纵它行动。",		-- 物品名:"复活的骨架"
		STALKER_ATRIUM = "我梦到过无数场景，可悲的是，你做出了错误的抉择。",		-- 物品名:"远古织影者"
		STALKER_MINION = "你还是想用毁灭你文明的力量来“守护”这个世界。",		-- 物品名:"编织暗影"
		-- 掉落物
		THURIBLE = "不如我的灯好看。",		-- 物品名:"暗影香炉"
		ARMORSKELETON = "往日的幽灵以另一种形式发挥它的作用。",		-- 物品名:"骨头盔甲"
		SKELETONHAT = "就当是又一场梦吧。",		-- 物品名:"骨头头盔"
	
		CHARLIE_NPC = "暗影的女王，找我是有什么事吗？。",	-- 物品名:"查理"
		CHARLIE_HAND = "你想要的东西…你想清楚了？",	-- 物品名:"召唤之手"

		-- 毒菌蟾蜍(蘑菇树)
		TOADSTOOL_CAP =
		{
			EMPTY = "里面在生长着什么。",		--蘑菇状态，冷却中
			INGROUND = "或许它还未完全长大？",		-- 蘑菇状态，在地里面
			GENERIC = "奇异的巨蕈，孢子会让人昏睡。",		-- 蘑菇状态，默认
		},
		-- 毒菌蟾蜍(战斗状态)
		TOADSTOOL =
		{
			GENERIC = "看起来它冬眠太久了，和巨蕈融为一体了。",		-- 物品名:"毒菌蟾蜍"->默认
			RAGE = "它好像生气了。",		-- 物品名:"毒菌蟾蜍"->愤怒
		},
		-- 毒菌蟾蜍技能召唤
		MUSHROOMBOMB = "昏睡孢子云。",		-- 物品名:"炸弹蘑菇"->蛤蟆战斗时种出来的炸弹
		MUSHROOMSPROUT =
		{
			GENERIC = "它在快速播种。",		-- 物品名:"孢子帽"->默认
			BURNT = "孢子易燃。",		-- 物品名:"孢子帽"->烧焦的
		},
		-- 掉落物
		SLEEPBOMB = "睡一觉吧！",		-- 物品名:"睡袋" 制造描述:"可以扔掉的袋子睡意沉沉。"
		SHROOM_SKIN = "大蟾蜍的蜕皮。",		-- 物品名:"蘑菇皮"
	-------天体风暴
		-- 充能玻璃石(月亮风暴内的特殊闪电生成的矿物)	
		MOONSTORM_GLASS = 
		{
			GENERIC = "尖锐的伤疤。",		-- 默认
			INFUSED = "能量外溢。"		-- 能量充盈
		},

		MOONSTORM_STATIC = "使用特殊的装置将月裔的能量约束。",		-- 物品名:"能量静电"
		MOONSTORM_STATIC_ITEM = "成功遏制。",		-- 物品名:"约束静电"
		
		MOONSTORM_SPARK = "被撕裂的空间。",		-- 物品名:"月熠"
		BIRD_MUTANT = "月亮拔下了你绚丽的乌羽。",		-- 物品名:"月盲乌鸦"
		BIRD_MUTANT_SPITTER = "被月亮风暴改造的鸟类。",		-- 物品名:"奇形鸟"
	-------天体裂隙
		LUNARRIFT_PORTAL = "来自月裔正在彻底改造这个世界。",	-- 物品名:"裂隙"
		LUNARRIFT_CRYSTAL = "看起来像其他时空的残渣。",	-- 物品名:"裂隙晶体"

		LUNARTHRALL_PLANT = "来自月亮的寄生生物。",	-- 物品名:"致命亮茄"
		LUNARTHRALL_PLANT_VINE_END = "打掉这些藤蔓能对它的本体造成影响。",	-- 物品名:"钻地藤蔓"

		LUNAR_GRAZER = "喜欢在睡梦中偷袭的生物。",	-- 物品名:"牧者"
	-------月亮线结局
		 --  幻灵捕获机
		GESTALT_CAGE =
		{
			GENERIC = "用它能够捕捉哪些虚影。",
			FILLED = "看起来的确有效。",
		},

		--  战争瓦器人：
		WAGBOSS_ROBOT_SECRET = "让我想到了年的鬼点子。",				-- 幕布状态
        WAGBOSS_ROBOT = "感觉不如年的玄极巨兵。",				-- 开机
        WAGBOSS_ROBOT_POSSESSED = "看起来这位先生对那些月裔还不够了解。",	-- 开始失控
		--  战争瓦器人的腿
		WAGBOSS_ROBOT_LEG = "至少它还能当掩体。",
		WAGBOSS_ROBOT_CONSTRUCTIONSITE      = "已经无力吐槽了。", -- 战争瓦器人(未完工的盖着布的形态)
		WAGBOSS_ROBOT_CONSTRUCTIONSITE_KIT  = "他就学不会吸取教训吗？", -- 战争瓦器人建筑套装
		WAGBOSS_ROBOT_CREATION_PARTS        = "加工水平一般。", -- 战争瓦器人零件

		MOONSTORM_STATIC_CATCHER            = "使用特殊方法能够约束能量。", -- 静电约束仪
		COOLANT = "奇特的物品。", -- 核化液

		--  天体仇灵
		ALTERGUARDIAN_PHASE1_LUNARRIFT = "卷土重来。",
		--  纯粹虚影
		ALTERGUARDIAN_PHASE1_LUNARRIFT_GESTALT = "它的核心露出来了。",
		--  天体后裔
        ALTERGUARDIAN_PHASE4_LUNARRIFT = "看来你为自己打造了一副新的身躯。",
		-- 未约束的静电
        MOONSTORM_STATIC_ROAMER = "新的力量在不断撕裂这片大地。",

		--  满地爬
		WAGDRONE_ROLLING =
        {
            GENERIC = "也许该找个鞭子抽你。",     --  敌对，活动
            INACTIVE = "处理起来比较麻烦。",    --  敌对，闲置
            DAMAGED = "修东西的事应该交给易。", --  损坏
            FRIENDLY = "工作效率不如器伥。",    --  友好，活动
        },

		--  黄莺(飞行无人机)
        WAGDRONE_FLYING =
        {
            GENERIC = "烦人的苍蝇。",               --  敌对，活动
            INACTIVE = "还是太笨重了。",     --  敌对，闲置
            DAMAGED = "也许还能用？",  --  损坏
        },

		--  陀螺传导核心(修满地爬的)
		WAGDRONE_PARTS = "兴许能修好那个陀螺。",

		--  无人机信标？存疑
		WAGDRONE_BEACON = "嗯？",

		--  概念制造器(奶奶岛的工作台)
        WAGPUNK_WORKSTATION = "至于这么邋遢吗。",
		--  杠杆选择器(战争瓦器人的拉杆)
        WAGPUNK_LEVER = "来吧。",
		--  基底扩展器(老瓦给的新码头)
        WAGPUNK_FLOOR_KIT = "足够结实。",
		--  动能场扩展器(生成能量墙的装置)
        WAGPUNK_CAGEWALL = "困兽之斗？",
		--  瓦格斯塔夫遗物
		WAGSTAFF_ITEM_1 = "这是实体，哎，你怎么似了。", --  手套
		WAGSTAFF_ITEM_2 = "这是实体……看来“祂”这次忍无可忍了。", --  剪贴板
		--  隐士迁居套装
        HERMITCRAB_RELOCATION_KIT = "帮那位女生找一个新家。",

		--  天体宝珠
        LUNAR_SEED = "一份来自月裔的战利品。",
		--  敌对虚影
        GESTALT_GUARD_EVOLVED = "看来你们很不服气啊。",
	-------地下裂隙
		SHADOWRIFT_PORTAL = "梦魇打开了新的入侵通路。",	-- 物品名:"暗影裂隙"
		DREADSTONE_STACK = "纯粹的绝望凝聚成固体石头。...",	-- 物品名:"绝望石生成"
		-- 墨荒三兄弟
		SHADOWTHRALL_HANDS = "急切的“躁动”。",	-- 物品名:"墨荒"->躁动
		SHADOWTHRALL_HORNS = "贪婪的“刮擦”。",	-- 物品名:"墨荒"->刮擦
		SHADOWTHRALL_WINGS = "慎重的“尖叫”。",	-- 物品名:"墨荒"->尖叫
		
		FUSED_SHADELING = "古怪的虫子，比之前遇到的更难对付。",	-- 物品名:"熔合暗影"
		SHADOWTHRALL_MOUTH = "阴谋得逞者——“狞笑”。",	--物品名:"墨荒"->苦笑暗影
		FUSED_SHADELING_BOMB = "Creeper？",	-- 物品名:"绝望螨"		

		--  恶液
		GELBLOB =
		{
			GENERIC = "奇怪的家伙。",	--物品名:"恶液"->默认
			HAS_ITEM = "顺手牵羊的小偷。",	--物品名:"恶液"->里面有东西
			HAS_CHARACTER = "看起来他运气不太好。",	--物品名:"恶液"->里面有玩家
		},

		--  面具生物相关
        SHADOWTHRALL_PARASITE = "嗯？拙劣的伪装，让我想起了那个臭棋篓子", --  面具生物
        -- 玩家的面具生物
		PLAYER_HOSTED =
        {
            GENERIC = "似是我梦见了你，还是你梦见了我？但你终究不是你，而我还是我。", --  别的角色
            ME = "真真假假，假假真真，不知我是我，与大梦何异？",        --  自己
        },
		--  面具
        MASK_SAGEHAT = "任人唯贤。",    --  贤者
        MASK_HALFWITHAT = "大智若愚。", --  愚人
        MASK_TOADYHAT = "跳梁小丑。",   --  马屁精
		
		-- 巨荒蜈/涟漪
		SHADOWTHRALL_CENTIPEDE =
		{
			HEAD = "双头巨蜈。", -- 头部
			BODY = "看起来它的身体很坚硬，得想办法让它绊倒。", -- 身体
			FLIPPED = "它的腹部比较脆弱，战机转瞬即逝。", -- 翻转
		},
---------- 自然生成布景---------------------------------------------------------------------------------
    ------ 自然资源
		SKELETON = "看来他运气不好。",		-- 物品名:"骷髅"
		SCORCHED_SKELETON = "看来他是被火烧死的。",		-- 物品名:"易碎骨骼"
		SKELETON_NOTPLAYER = "有情人，终不成其好。",	-- 物品名:"骷髅"（情人节彩蛋）
       
		SHALLOW_GRAVE = "茔茔蔓草，岁岁不老；风雨如晦，死生为谁。", --  矮坟
		
		 -- 落石
		CAVEIN_BOULDER =
		{
			GENERIC = "看起来它不是很重，我能挪动它。",		-- 物品名:"岩石"->可以搬动的岩石
			RAISED = "太远了。",		-- 物品名:"岩石"->洞穴内蚁狮地震时落在中间被其他石头托起
		},
		ROCK = "我需要凿碎它才能拿到里面的东西。",		-- 物品名:"岩石"
		-- 石化树
		PETRIFIED_TREE = "突如其来的诅咒。",		-- 物品名:"石化树"
		ROCK_PETRIFIED_TREE = "突如其来的诅咒。",		-- 物品名:"石化树"
		ROCK_PETRIFIED_TREE_OLD = "突如其来的诅咒。",		-- 物品名:"石化树"->枯树

		-- 石笋
		STALAGMITE = "石笋凝烟。",		-- 石笋
		STALAGMITE_FULL			= "孤“山”。",-- 大
		STALAGMITE_LOW			= "削峰为砚。",-- 中
		STALAGMITE_MED			= "残峰见底。",-- 小
		-- 石笋柱
		STALAGMITE_TALL = "石笋如卓笔，悬岩列仙谱。",		-- 石笋柱
		STALAGMITE_TALL_FULL	= "君不见益州城西门，陌上石笋双高蹲。",-- 大
		STALAGMITE_TALL_LOW		= "“如笋拔地，徒余残羹。",-- 中
		STALAGMITE_TALL_MED		= "岁月悠悠,未度余笋。",-- 小
		
		-- 迷你冰川
		ROCK_ICE =
		{
			GENERIC = "不知道在炎夏时节，你还能坚挺吗。",		-- 物品名:"迷你冰川"->默认
			MELTED = "天开月明，海走冰散。",		-- 物品名:"迷你冰川"->融化了
		},
		ROCK_ICE_MELTED = "或许我该把功率调大点？",		-- 物品名:"融化的迷你冰川"

		-- 盐堆(盐矿)
		SALTSTACK =
		{
			GENERIC = "往事不堪回首，望断天涯。",		-- 物品名:"盐堆"->默认
			MINED_OUT = "它还会慢慢长出来。",		-- 物品名:"盐堆"->被采完了
			GROWING = "它正在缓慢生长。",		-- 物品名:"盐堆"->正在生长
		},

		NITRE_FORMATION = "酸霖蚀渊池，凝霜覆苍苔。",	-- 物品名:"硝石堆"
	------ 可交互自然生成的布景
		MULTIPLAYER_PORTAL = "只出不进。",		-- 物品名:"绚丽之门"
		MULTIPLAYER_PORTAL_MOONROCK = "或许我该回去了?",		-- 物品名:"天体传送门"
		CONSTRUCTION_PLANS = "使用月亮的力量联同其他世界。",		-- 物品名:"建造计划"->升级绚丽之门至天体传送门

		TREASURECHEST_TRAP = "感觉不对劲，最好不要随便打开它。",		-- 物品名:"宝箱"->陷阱

		-- 月台
		MOONBASE =
		{
			GENERIC = "中间可以放东西，或许是一根法杖？",		-- 物品名:"月亮石"->默认
			BROKEN = "看来它需要被修缮一番了。",		-- 物品名:"月亮石"->坏了
			STAFFED = "月亮的力量似乎可以强化它？",		-- 物品名:"月亮石"->插上唤星者之杖
			WRONGSTAFF = "似乎不对。",		-- 物品名:"月亮石"->插错法杖
			MOONSTAFF = "月亮的祝福让顶上的宝石更绚丽了，但失去了温度。",		-- 物品名:"月亮石"->已经插了法杖的（月杖）
		},
		GARGOYLE_HOUND = "看起来月亮并不喜欢你。",		-- 物品名:"可疑的月岩"->石化成月岩的猎犬
		GARGOYLE_WEREPIG = "它的疯狂被凝固。",		-- 物品名:"可疑的月岩"->石化成月岩的疯猪
		MOONROCK_PIECES = "终成灰。",		-- 物品名:"月亮石碎块"（月台周围生成的小碎块）

		RESURRECTIONSTONE = "似乎有人特意放置了它，是那个女孩？但是为什么？",		-- 物品名:"试金石"
			
		-- 坟墓
		MOUND =
		{
			DUG = "看来被人捷足先登了。",		-- 物品名:"坟墓"->被挖了
			GENERIC = "寻龙分金看缠山,一重缠是一重关。",		-- 物品名:"坟墓"->默认
		},
        -- 湖泊(绿洲)
		OASISLAKE =
		{
			GENERIC = "蒲海晓霜凝马尾，葱山夜雪扑旌竿。",		-- 物品名:"湖泊"->有水
			EMPTY = "黄沙埋尽旧时波，枯涸唯余断月痕。",		-- 物品名:"湖泊"->干了
		},
		SUCCULENT_PLANT = "这是芦荟？感觉不太像。",		-- 物品名:"多肉植物"
		SUCCULENT_PICKED = "我能吃那个，但我不想吃。",		-- 物品名:"多肉植物"
	-----垃圾堆	
		
		FENCE_JUNK = "还不至于用这些做栅栏。",	--物品名:"垃圾栅栏"
		JUNK_PILE = "里面也许有什么能用得上的东西。",	--物品名:"垃圾堆"
		JUNK_PILE_BIG = "里面会有什么吗？",	--物品名:"摇摇欲坠的垃圾堆"

		OCEANFISHABLEFLOTSAM = "被遗弃的垃圾，还是他人的遗物呢？",		-- 物品名:"海洋残骸"
		BOATFRAGMENT03 = "就剩下了这一点。",		-- 物品名:"船碎片"
		BOATFRAGMENT04 = "就剩下了这一点。",		-- 物品名:"船碎片"
		BOATFRAGMENT05 = "就剩下了这一点。",		-- 物品名:"船碎片"

		SEASTACK = "这是一块石头。",		-- 物品名:"海蚀柱"
	------ 水中木
		WATERTREE_PILLAR = "巨大的树。",		-- 物品名:"大树干"
		WATERTREE_ROOT = "它的根系覆盖很广阔。",		-- 物品名:"大树根"
	------ 月岛
		-- 天体裂隙
		MOON_FISSURE =
		{
			GENERIC = "月裔的低语在裂隙中回响。",		-- 物品名:"天体裂隙"->默认
			NOLIGHT = "它在回应望月。",		-- 物品名:"天体裂隙"->发光谷值时间段
		},

		MOON_ALTAR_ROCK_IDOL = "看起来里面是一尊雕塑，你想出来透透气？",		-- 物品名:"吸引人的结构"->被岩石包裹的天体祭坛雕像
		MOON_ALTAR_ROCK_GLASS = "看起来里面是一个底座，你想出来透透气？",		-- 物品名:"吸引人的结构"->被岩石包裹的天体祭坛底座
		MOON_ALTAR_ROCK_SEED = "看起来里面是一颗宝球，你想出来透透气？",		-- 物品名:"吸引人的结构"->被岩石包裹的天体祭坛宝球

		MOON_ALTAR_IDOL = "应该还缺失的地方。",		-- 物品名:"天体祭坛雕像"
		MOON_ALTAR_GLASS = "你想去哪里呢？",		-- 物品名:"天体祭坛底座"
		MOON_ALTAR_SEED = "看来你想去那个裂隙里呆着。",		-- 物品名:"天体祭坛宝球"
		-- 天体祭坛
		MOON_ALTAR =
		{
			MOON_ALTAR_WIP = "还缺少什么东西。",		-- 物品名:"组装一半的祭坛"
			GENERIC = "你想和“我”分享你的视界？",		-- 物品名:"天体祭坛"->默认
		},
	
		MOON_ALTAR_CROWN = "看来他想守护的就是你了。",		-- 物品名:"未激活天体贡品"
		MOON_ALTAR_COSMIC = "似乎还有什么事情没有完成。",		-- 物品名:"天体贡品"

		MOON_ALTAR_ASTRAL = "它似乎是一个更大机制的一部分。",		-- 物品名:"天体圣殿"
		MOON_ALTAR_ICON = "我知道把你放哪了。",		-- 物品名:"天体圣殿象征"
		MOON_ALTAR_WARD = "它需要和其他的那些放在一起。",		-- 物品名:"天体圣殿卫戍"

		-- 月岛温泉
		HOTSPRING =
		{
			GENERIC = "春寒赐浴华清池，温泉水滑洗凝脂。",		-- 物品名:"温泉"->默认
			BOMBED = "滚烫的水。",		-- 物品名:"温泉"->投入浴盐球
			GLASS = "就当是琉璃瓦吧。",		-- 物品名:"温泉"->结出玻璃
			EMPTY = "它还会涨出来的。",		-- 物品名:"温泉"->刚开采完
		},

		DEAD_SEA_BONES = "至少它还能回归陆地。",		-- 物品名:"海骨"				
		MOONGLASS_ROCK = "干明可鉴，不过它应该承受不了太多次的打击。",		-- 物品名:"月光玻璃"
		-- 浮木(月岛)
		DRIFTWOOD_TREE =
		{
			BURNING = "水与火的洗礼。",		-- 物品名:"浮木"->正在燃烧
			BURNT = "看起来没什么用了。",		-- 物品名:"浮木"->烧焦的
			CHOPPED = "也许还有其他东西被压在下面。",		-- 物品名:"浮木"->被砍了
			GENERIC = "一颗枯木。",		-- 物品名:"浮木"->默认
		},
		DRIFTWOOD_LOG = "能浮在水上。",		-- 物品名:"浮木桩"
	------ 奶奶岛/寄居蟹隐士岛
	---注：瓶中信和瓶罐在杂物-自然生成栏
		HERMITCRAB = "长期孤独让她有很多怨言。",		-- 物品名:"寄居蟹隐士"

		HERMIT_PEARL = "希望我能找到你的心上人。",		-- 物品名:"珍珠的珍珠"
		HERMIT_CRACKED_PEARL = "希望她能释怀。",		-- 物品名:"开裂珍珠"
		-- 隐士之家
		HERMITHOUSE = {
			GENERIC = "破败不堪的小屋。",		-- 物品名:"隐士之家"->默认
			BUILTUP = "看起来温馨多了。",		-- 物品名:"隐士之家"->升级过
		},

		MOON_FISSURE_PLUGGED = "简单粗暴的方法，但是她还是成功把那些月裔压下去了。",		-- 物品名:"堵住的裂隙"
		SHELL_CLUSTER = "一堆贝壳。",		-- 物品名:"贝壳堆"
		-- 隐士蜂箱
		BEEBOX_HERMIT =
		{
			READY = "正午云桥疏雨过，冬青花上蜜蜂归。",		-- 物品名:"蜂箱"->快满了
			FULLHONEY = "蜂不禁人采蜜忙，荷花蕊里作蜂房。",		-- 物品名:"蜂箱"->蜂蜜满了
			GENERIC = "钱郎嗜读书，巧若蜂采蜜。",		-- 物品名:"蜂箱"->默认
			NOHONEY = "需要耐心等待了。",		-- 物品名:"蜂箱"->没有蜂蜜
			SOMEHONEY = "还不是时候。",		-- 物品名:"蜂箱"->有一些蜂蜜
			BURNT = "可惜了，唉。",		-- 物品名:"蜂箱"->烧焦的
		},
		-- 隐士温泉
		HERMITHOTSPRING  =
		{
			BOMBED  = "汤泉浴身，百骸舒泰。",          -- 沸腾
			GENERIC = "只差一个沐浴球。", -- 普通
			EMPTY   = "人走茶凉，这里已经被荒废了。",              -- 干涸
		},
		HERMITHOTSPRING_CONSTR = "该让易来干这个。", -- 隐士温泉(建造中)

		-- 隐士巨型晾肉架
		MEATRACK_HERMIT_MULTI =
		{
			DONE            = "制备完成。", -- 完成
			DRYING          = "稍安勿躁。", -- 干燥中
			DRYINGINRAIN    = "雨水会把肉打湿。", -- 雨中干燥
			GENERIC         = "加量不加架。", -- 普通
			BURNT           = "有些过火了。", -- 烧焦
			DONE_NOTMEAT    = "处理好了。", -- 非肉类完成
			DRYING_NOTMEAT  = "稍安勿躁。", -- 非肉类干燥中
			DRYINGINRAIN_NOTMEAT = "雨天可不适合晾晒。", -- 非肉类雨中干燥
			DONE_SALT       = "一举多得。", -- 落下盐晶
			ABANDONED       = "人走茶凉，这里已经被荒废了。", -- 废弃
		},
		HERMITHOUSE_ORNAMENT = "添砖加瓦。",        -- 隐士房屋装饰
		HERMITHOUSE_LAUNDRY = "比年的恶作剧都更惹人厌。",   -- 寄居蟹隐士的内衣

		-- 隐士螃蟹茶馆
		HERMITCRAB_TEASHOP =
		{
			GENERIC = "看来已经打烊了。", -- 珍珠不在
			ACTIVE  = "来一杯吗？", -- 珍珠在
			BREWING = "且学公家煮茗波，自看蟹眼注新泉。", -- 泡茶中
			BURNT   = "毁于一旦。", -- 烧毁
		},

		-- 寄居蟹隐士灯柱
		HERMITCRAB_LIGHTPOST =
		{
			GENERIC = "装饰性的路灯。", -- 普通
			ABANDONED = "没有人，就莫了生机。", -- 废弃
		},
		HERMITCRAB_LIGHTPOST_ITEM = "这是为珍珠女士准备的。", -- 隐士螃蟹灯柱物品形式
	------ 瓶罐交易
		TACKLESKETCH = "看起来确实值得。",		-- 物品名:"{item}广告"
		
		CHUM = "美味的陷阱。",		-- 物品名:"鱼食" 制造描述:"鱼儿的美食。"
		
		OCEANFISHINGLURE_HERMIT_RAIN = "竿风月，一蓑烟雨。",		-- 物品名:"雨天鱼饵" 制造描述:"留着雨天用。"
		OCEANFISHINGLURE_HERMIT_SNOW = "雪鬓衰髯白布袍，笑携赪鲤换村醪。",		-- 物品名:"雪天鱼饵" 制造描述:"雪天适合用它钓鱼。"
		OCEANFISHINGLURE_HERMIT_DROWSY = "很有效果。",		-- 物品名:"麻醉鱼饵" 制造描述:"把鱼闷住就抓住了一半。"
		OCEANFISHINGLURE_HERMIT_HEAVY = "沉钩绝渊，缚鳞擎山。",		-- 物品名:"重量级鱼饵" 制造描述:"钓一条大鱼！"

		HERMIT_BUNDLE = "礼尚往来。",		-- 物品名:"一包谢意"
		HERMIT_BUNDLE_SHELLS = "均会喜欢这个的，只可惜她还是不愿高歌。",		-- 物品名:"贝壳钟包" 制造描述:"她卖的贝壳。"
		-- 贝壳钟
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "声沉黄钟，鸣泉涌瓮。",		-- 物品名:"低音贝壳钟"->默认
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "振玉叩商，中和以清。",		-- 物品名:"中音贝壳钟"->默认
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "裂帛徵羽，穿云裂石。",		-- 物品名:"高音贝壳钟"->默认
		},
		-- 沉底宝箱
		SUNKENCHEST =
		{
			GENERIC = "打开一把锁有时候不一定需要钥匙。",		-- 物品名:"沉底宝箱"->默认
			LOCKED = "贝壳闭上了！",		-- 物品名:"沉底宝箱"->锁住了
		},

		-- 盐晶组合机
		SHELLWEAVER = "珍珠为我们提供了一份助力。", -- 盐晶组合机

		ICESTAFF2 	= "凛冽寒冰。", -- 闪冻魔杖
		ICESTAFF3 	= "彻骨通寒。", -- 深冻魔杖

		NONSLIPGRIT = "稳步迈进。", -- 防滑粉
		NONSLIPGRITBOOSTED = "偕行度玄冰。", -- 防滑颗粒

		DESICCANT 		 =	 "应当在我的诗卷中放一包。", -- 小包干燥剂
		DESICCANTBOOSTED = "比之沧海，仍为一粟。", -- 大包干燥剂

		HERMITCRAB_SHELL = "呼唤回归。", 	-- 搬运海螺

		SALTY_DOGHAT 	 = "向着大海。", -- 咸狗帽
		SALTY_DOG		 = "你好啊，小家伙？", -- 咸狗
	------ 猴岛
		MONKEYISLAND_PORTAL = "这是一个单向连接到其他世界的传送门废墟。",	-- 物品名:"非自然传送门"
		MONKEYISLAND_PORTAL_DEBRIS = "看来是那位奇怪的幻影干的。",	-- 物品名:"损坏的机器"
		
		MONKEYQUEEN = "海盗女王。",	-- 物品名:"月亮码头女王"
		MONKEYPILLAR = "看起来真高。",	-- 物品名:"猴子柱"
		PIRATE_FLAG_POLE = "海盗的旗帜。",	-- 物品名:"月亮码头海盗旗"

		BLACKFLAG = "黑旗海盗。",	-- 物品名:"黑旗"
	------ 古董船	
		BOAT_ANCIENT_ITEM = "科技全靠考古。",	--物品名:"古董船套装"
		BOAT_ANCIENT_CONTAINER = "能放不少东西。",	--物品名:"货舱"
		WALKINGPLANK_ANCIENT = "救生小艇也许被开走了。",	--物品名:"古董木板"
	------ 暗影三祺子(三基佬)相关
        -- 骑士的头
		SCULPTURE_KNIGHTHEAD = "开玩笑也不能只有个头吧。",		-- 物品名:"可疑的大理石"->骑士的头
		-- 骑士雕像
		SCULPTURE_KNIGHTBODY =
		{
			COVERED = "感觉这个雕像里面还有东西。",		-- 骑士雕像被裹住，可以开采大理石
			UNCOVERED = "里面的东西看起来缺了点什么。",		-- 开采后骑士雕像露出来了
			FINISHED = "一只骑士？",		-- 骑士雕像修好了
			READY = "暗影的力量在雕塑里面汇聚。",		-- 骑士雕像在晃动
		},
		-- 主教的头
		SCULPTURE_BISHOPHEAD = "这是喜欢分头行动吗？",		-- 物品名:"可疑的大理石"->主教的头
		-- 主教雕像
		SCULPTURE_BISHOPBODY =
		{
			COVERED = "有后期修复的痕迹。",		--主教雕像被裹住，可以开采大理石
			UNCOVERED = "看来他是位劈头士。",		-- 开采后主教雕像露出来了
			FINISHED = "一位主教？",		-- 主教雕像修好了
			READY = "暗影的力量在雕塑里面汇聚。",		-- 主教雕像在晃动
		},
		-- 战车的鼻子
		SCULPTURE_ROOKNOSE = "奇怪的雕塑碎片。",		-- 战车的鼻子
		-- 战车雕像
		SCULPTURE_ROOKBODY =
		{
			COVERED = "未完成的雕塑吗？",		-- 战车雕像被裹住，可以开采大理石
			UNCOVERED = "似乎少了什么。",		-- 开采后战车雕像露出来了
			FINISHED = "一辆战车？",		-- 战车雕像修好了
			READY = "暗影的力量在雕塑里面汇聚。",		-- 战车雕像在晃动
		},
	-----远古
		-- 远古大门
		ATRIUM_GATE =
		{
			ON = "试试看吧。",		-- 物品名:"远古大门"->开启
			OFF = "和萨米的那个巨构很像，谁都不知道这会带来新的希望还是更彻底的毁灭。",		-- 物品名:"远古大门"->关闭
			CHARGING = "它在吸收力量并运行。",		-- 物品名:"远古大门"->充能中
			DESTABILIZING = "不太对劲。",		-- 物品名:"远古大门"->不稳定
			COOLDOWN = "它需要时间恢复。我也是。",		-- 物品名:"远古大门"->冷却中
		},
		-- 远古壁画
		ATRIUM_RUBBLE =
		{
			LINE_1 = "一副远古壁画，描绘了饥荒，悲观，还有恐惧。",		-- 物品名:"远古壁画"->第一行
			LINE_2 = "太过陈旧，它记录的内容已经流逝在时间长河了。",		-- 物品名:"远古壁画"->第二行
			LINE_3 = "对噩梦燃料的开发使这个文明的技术飞速发展。",		-- 物品名:"远古壁画"->第三行
			LINE_4 = "来自另一个世界的梦魇将这个文明毁灭了。",		-- 物品名:"远古壁画"->第四行
			LINE_5 = "高贵的王无法拯救自己的爱人与子民，只能以自己为代价阻挠黑暗的侵蚀。",		-- 物品名:"远古壁画"->第五行
		},

		-- 遗物(远古的石桌、石椅)
		RELIC =
        {
            GENERIC = "漫漫长路，独行时光。",
            BROKEN = "已经什么都不剩了。",
        },		
		RUINS_RUBBLE = "自远古留存下来的遗物。",		-- 物品名:"损毁的废墟"
		RUBBLE = "很不幸，它没能留存到现在。",		-- 物品名:"碎石"
		-- 远古雕像
		ANCIENT_STATUE = "这些雕像还能影响魔力流动，或许我该敲掉它。",		-- 远古雕像
		RUINS_STATUE_MAGE = "曾盛极一时，须臾而亡。", 					-- 远古雕像(可开采)
		ATRIUM_STATUE = "它们不甘于黑暗，化身雕塑，承受永恒的折磨。",		-- 中庭远古雕像

		NIGHTMARELIGHT = "它里面有不同寻常了力量。",		-- 物品名:"梦魇灯座"
		ATRIUM_OVERGROWTH = "这些铭文记录着远古的辉煌与衰落。",		-- 物品名:"远古方尖碑"
		PANDORASCHEST = "似乎是上个文明的遗产。",		-- 物品名:"华丽箱子"
		-- 远古宝箱
		TREECLUMP = "这是个陷阱？还是一番机遇？", 		-- 远古宝箱
		SACRED_CHEST =
		{
			GENERIC = {
				"里面似乎有另一方小天地？",		-- 物品名:"远古宝箱"->默认
				"似乎有一个特殊的谜题？",		-- 物品名:"远古宝箱"->默认
				"使用铥矿徽章做媒介能和这方小天地的人们进行“交流”。",		-- 物品名:"远古宝箱"->默认
			},
			LOCKED = "它正在做出判断。",		-- 物品名:"远古宝箱"->锁住了
		},
		-- 远古灯柱
		ATRIUM_LIGHT =
		{
			ON = "恐惧与黑暗为他提供动力。",		-- 物品名:"远古灯柱"->开启
			OFF = "看起来能源供应被切断了。",		-- 物品名:"远古灯柱"->关闭
		},
		-- 方尖碑(高理智)
		SANITYROCK =
		{
			ACTIVE = "看来它更喜欢理智的人。",		-- 物品名:"方尖碑"->理智低的时候激活了
			INACTIVE = "朝霞织星汉，叹尽梦因缘。",		-- 物品名:"方尖碑"->理智高的时候没有激活
		},
		-- 方尖碑(低理智)
		INSANITYROCK =
		{
			ACTIVE = "它更喜欢疯狂的人。",		-- 物品名:"方尖碑"->理智高的时候激活了
			INACTIVE = "这份“癫狂”，喜欢吗？",		-- 物品名:"方尖碑"->理智低的时候没有激活
		},
	-----月亮蘑菇林
		MUSHGNOME = "旋转，跳跃，闭着眼。",		-- 物品名:"蘑菇地精"

		MOON_CAP = "只是看着就会让人昏昏沉沉的。",		-- 物品名:"月亮蘑菇"
		MOON_CAP_COOKED = "提神醒脑，但是肚子不太舒服。",		-- 物品名:"熟月亮蘑菇"
		MUSHTREE_MOON = "看来这些蘑菇也受月亮影响而变异了。",		-- 物品名:"月亮蘑菇树"
		SPORE_MOON = "月裔改造后的地精会释放这种危险的孢子。",		-- 物品名:"月亮孢子"
	
		GROTTO_POOL_BIG = "这算是奇观，还是危险的诅咒？",		-- 物品名:"玻璃绿洲"
		GROTTO_POOL_SMALL = "这算是奇观，还是危险的诅咒？",		-- 物品名:"小玻璃绿洲"
		
		NIGHTMAREGROWTH = "黑暗的女王，你又有什么盘算？",		-- 物品名:"梦魇城墙"

	------ 远古档案馆
		WALL_STONE_2 = "精致的墙壁。",		-- 物品名:"档案馆石墙"
		WALL_RUINS_2 = "古老的墙垣。",		-- 物品名:"档案馆铥墙"
		-- 知识饮水机
		ARCHIVE_LOCKBOX_DISPENCER = 
		{
			POWEROFF = "似乎缺少能源。",		-- 物品名:"知识饮水机"->能源未启用
			GENERIC =  "你想同我分享什么？",		-- 物品名:"知识饮水机"->默认
		},
		ARCHIVE_ORCHESTRINA_MAIN = "好像专门做成让人摸不着头脑的样子。",	-- 物品名:"远古小合奏机"
		ARCHIVE_LOCKBOX = "似乎需要用特殊的装置进行提取。",		-- 物品名:"蒸馏的知识"
		-- 远古窑
		ARCHIVE_COOKPOT =
		{
			COOKING_LONG = "在等等。",		--饭还需要很久
			COOKING_SHORT = "就快好了。",		-- 饭快做好了
			DONE = "不知道来自远古厨具做出的东西有什么特殊？",	-- 完成了
			EMPTY = "不知道还能不能用。",		-- 空的
			BURNT = "烤过头了。",		-- 烧焦的
		},

		ARCHIVE_MOON_STATUE = "石髓琢冰轮，清辉凝万古。",		-- 物品名:"远古月亮雕像"
		-- 远古月亮符文石
		ARCHIVE_RUNE_STATUE =
		{
			LINE_1 = "一种古老的文字，似乎处在早期演化阶段。",		-- 第一行
			LINE_2 = "月亮让他们着迷。",								-- 第二行
			LINE_3 = "这个文明的辉煌远不止于此，各个世界都有它们征战的痕迹。",	-- 第三行
			LINE_4 = "这个被反复提及的名字…情况比预想的还要糟糕。",		-- 第四行
			LINE_5 = "弱小和无知不是生存的障碍，傲慢才是。",		-- 第五行
		},
		-- 远古哨所
		ARCHIVE_SECURITY_DESK = 
		{
			POWEROFF = "没有能源，也只是一堆废墟罢了。",		-- 物品名:"远古哨所"->能源未启用
			GENERIC = "精妙的哨戒装置。",		-- 物品名:"远古哨所"->默认
		},
		ARCHIVE_SECURITY_PULSE = "它在巡逻。",		-- 物品名:"远古哨所脉冲"		
		-- 华丽基座
		ARCHIVE_SWITCH = 
		{
			VALID = "它看起来是由这些宝石供能。",		-- 物品名:"华丽基座"->有效
			GEMS = "似乎需要特殊的宝石来驱动。",		-- 物品名:"华丽基座"->需要宝石
		},
		-- 被封印的传送门
		ARCHIVE_PORTAL = 
		{
			POWEROFF = "或许需要能源？",		-- 物品名:"封印的传送门"->能源未启用
			GENERIC = "又一个远古时代的传送门。",		-- 物品名:"封印的传送门"->默认
		},
	------ 远古圣殿
		OCEANWHIRLBIGPORTALEXIT = "看起来漩涡将物品都冲到这里堆积起来了。", -- 海洋漂浮物
		-- 追随者(一起踩石柱的雕像)
		ABYSSPILLAR_MINION =
		{
			GENERIC   = "似乎是某种机械？不知道会不会妨碍我。", -- 关闭
			ACTIVATED = "邯郸学步。", -- 激活
		},
		-- 圣殿谜题开关拉杆
		ABYSSPILLAR_TRIAL = "开始吧。",
		-- 圣殿路标
		VAULT_TELEPORTER =
		{
			GENERIC   = "很先进的技术，比那几位天师掌握的更加先进。", -- 普通
			BROKEN    = "沧海化桑田。", -- 损坏
			UNPOWERED = "似乎缺少能量。", -- 无动力
		},
		VAULT_ORB        = "门钥匙。", -- 传送宝珠
		VAULT_LOBBY_EXIT = "谁不喜欢纵身跃入深渊？", -- 裂口
		VAULT_CHANDELIER_BROKEN = "一场溃灭的遗留物。", -- 破碎的宝库吊灯

		ANCIENT_HUSK = "湮灭前的抵抗，也是勇气的象征。", -- 远古遗骸

		MASK_ANCIENT_HANDMAIDHAT  = "你可曾预见自取灭亡的末路？", -- 远见者
		MASK_ANCIENT_ARCHITECTHAT = "被造物反噬。", 		 -- 工匠
		MASK_ANCIENT_MASONHAT     = "领袖总要负担重任，不是吗？", -- 鞘翅

		-- 谜之火焰
		VAULT_TORCH =
		{
			GENERIC = "呵，经典的益智游戏。", -- 普通
			BROKEN  = "这个的开关坏了。", -- 损坏
		},
	------ 主世界其他布景
		-- 舞台之手
		STAGEHAND =
		{
			AWAKE = "恐惧光明，又追逐光明，难以理解。",		-- 物品名:"舞台之手"->醒了
			HIDING = "你是见不得光吗？",		-- 物品名:"舞台之手"->藏起来了
		},
		 -- 大理石雕像
		STATUE_MARBLE =
		{
			GENERIC = "在象棋中，被兵卒围死抵得上三局。",		-- 物品名:"大理石雕像"->卒子
			TYPE1 = "看起来它的头被人为破坏了。",		-- 物品名:"大理石雕像"->持剑无头查理
			TYPE2 = "无头的假面愚者雕塑。",		-- 物品名:"大理石雕像"->持杖无头查理
			TYPE3 = "我想知道是哪个艺术家的作品。", --bird bath type statue		-- 物品名:"大理石雕像"->水瓶
		},
		STATUEHARP = "某处神话传说中的看起来像是弹琴的小萨科塔，同样没有头。",		-- 物品名:"竖琴雕像"
		STATUEMAXWELL = "只有他的雕塑有头。",		-- 物品名:"麦斯威尔雕像"
		-- 舞台剧
		CHARLIE_STAGE_POST = "台上十分钟，台下十年功。",	-- 物品名:"舞台"
		CHARLIE_LECTURN = "记录的历史，还是篡写的戏言。",	-- 物品名:"剧本"
		-- 多刺舞台之手
		STAGEUSHER =
		{
			STANDING = "看来你很不满。",	-- 物品名:"舞台之手"->被敲击后站起来攻击玩家
			SITTING = "带刺的蔷薇可是很危险。",	-- 物品名:"舞台之手"->默认
		},
		CHARLIE_HECKLER = "暗影的观众。",	-- 物品名:"嘲鸫"

		PLAYBILL_THE_DOLL = "“由 C.W. 撰写”",	-- 舞台剧玩偶

		STATUEHARP_HEDGESPAWNER = "花长回来了，但头却没有。",	-- 物品名:"荆棘密布的雕像"
		
		HEDGEHOUND = "美丽的花朵狼。",	-- 蔷薇狼
		HEDGEHOUND_BUSH = "奇怪的灌木丛。",	-- 蔷薇丛

		MASK_DOLLHAT = "一张玩偶面具。",				-- 物品名:"玩偶面具"
		MASK_DOLLBROKENHAT = "一张开裂的玩偶面具。",	-- 物品名:"开裂玩偶面具"
		MASK_DOLLREPAIREDHAT = "一张曾经的玩偶面具。",	-- 物品名:"破碎玩偶面具"
		MASK_BLACKSMITHHAT = "一张铁匠面具。",			-- 物品名:"铁匠面具"
		MASK_MIRRORHAT = "一张面具，但它看起来像一面镜子。",-- 物品名:"镜子面具"
		MASK_QUEENHAT = "一张女王面具。",			-- 物品名:"女王面具"
		MASK_KINGHAT = "一张国王面具。",			-- 物品名:"国王面具"
		MASK_TREEHAT = "一张树的面具。",			-- 物品名:"树的面具"
		MASK_FOOLHAT = "一张小丑面具。",			-- 物品名:"小丑面具"

		COSTUME_DOLL_BODY = "玩偶的戏服。",			-- 物品名:"玩偶服"
		COSTUME_QUEEN_BODY = "女王的戏服。",		-- 物品名:"女王服"
		COSTUME_KING_BODY = "国王的戏服。",			-- 物品名:"国王服"
		COSTUME_BLACKSMITH_BODY = "铁匠的戏服。",	-- 物品名:"铁匠服"
		COSTUME_MIRROR_BODY = "一套戏服。",			-- 物品名:"镜子服"
		COSTUME_TREE_BODY = "树的戏服。",			-- 物品名:"树木服"
		COSTUME_FOOL_BODY = "小丑的戏服。",			-- 物品名:"小丑服"

		-- 鱼人头
		MERMHEAD =
		{
			GENERIC = "看来这是猪人在战争中斩杀的鱼人。",		-- 物品名:"鱼人头"->默认
			BURNT = "浓烈的腥臭味。",		-- 物品名:"鱼人头"->烧焦的
		},
		-- 猪头
		PIGHEAD =
		{
			GENERIC = "某种祭品，亦或者是鱼人的战利品。",		-- 物品名:"猪头"->默认
			BURNT = "就算被火烧焦了不能吃。",		-- 物品名:"猪头"->烧焦的
		},
		
		PIGKING = "胖胖的猪人王，出手倒是阔绰。",		-- 物品名:"猪王"
	------ 月后生物尸体
		-- 鸟尸体
		BIRDCORPSE =
		{
			GENERIC  = "结束了。", -- 目睹
			BURNING  = "尘归尘，土归土。", -- 燃烧
			REVIVING = "可悲，甚至无法长眠。", -- 复活
		},
		-- 秃鹫尸体
		BUZZARDCORPSE =
		{
			GENERIC  = "食腐者的末路。", -- 目睹
			BURNING  = "尘归尘，土归土。", -- 燃烧
			REVIVING = "唉……令人憎恶。", -- 复活
		},
		-- 变异秃鹫
		MUTATEDBUZZARD_GESTALT =
		{
			GENERIC         = "口吐死火的怪物，倒是让我想起了一只红龙",       -- 普通
			EATING_CORPSE   = "贪得无厌。", -- 吃尸体
		},
		-- 企鹅尸体
		PENGUINCORPSE =
		{
			GENERIC  = "尾声。", -- 目睹
			BURNING  = "划上休止符。", -- 燃烧
			REVIVING = "讨厌的月裔。", -- 复活
		},
		-- 蜘蛛尸体
		SPIDERCORPSE =
		{
			GENERIC = "结束了。", -- 目睹
			BURNING = "可惜没有焚化炉。", -- 燃烧
			REVIVING = "连这个都要收为化身？", -- 复活
		},

		-- 蜘蛛女王尸体
		SPIDERQUEENCORPSE =
		{
			GENERIC = "结束了。", -- 目睹
			BURNING = "至少比变成怪物强。", -- 燃烧
			REVIVING = "死罪可逃，活罪难免。", -- 复活
		},

		-- 鱼人尸体
		MERMCORPSE =
		{
			GENERIC  = "你会魂归何处？", -- 目睹
			BURNING  = "一股烤鱼味。", -- 燃烧
			REVIVING = "哎，你就不能安分点吗。", -- 复活
		},

		-- 通用尸体
		GENERIC_CORPSE =
		{
			GENERIC  = "生死有命。",  -- 目睹
			BURNING  = "很遗憾，你不能入土为安了。",      -- 燃烧
			REVIVING = "玩弄尸体的恶趣味，令人作呕。",    -- 复活
		},
---------- 杂物	--------------------------------------------------------------------
    ------ 玩家制作&掉落物	----------------------------
		MAPSCROLL = "我去过这里吗？记不得了，也许梦到过吧。",		-- 地图卷轴
		SPOILED_FOOD = "看来这些食物已经彻底霉变了。",		-- 腐烂物
	------ 地皮
		TURF_DIRT = "一块带着泥土味的地皮。",					-- 泥土地皮
		TURF_FOREST = "一块带着森林腐质的地皮。",				-- 森林地皮
		TURF_GRASS = "一块带着草根的地皮。",					-- 长草地皮
		TURF_MARSH = "一块泥泞腥臭的地皮。",					-- 沼泽地皮
		TURF_DESERTDIRT = "黄沙，白骨，让我想起了从军的日子。",	-- 沙漠地皮
		TURF_MUD="泥泞的地面。",								-- 泥泞地皮
		TURF_BADLANDS = "贫瘠的土壤。",					-- 贫瘠土壤地皮（单机）
		TURF_DECIDUOUS = "桦树森林的地皮。",			-- 桦树地皮
		TURF_SAVANNA = "一块茂密的草地皮。",			-- 热带草原地皮
		TURF_WOODFLOOR = "一块木地板。",				-- 木地板
		TURF_CARPETFLOOR = "柔软。",					-- 地毯地板
		TURF_CARPETFLOOR2 = "更柔软的地毯，想睡一觉了。",	-- 茂盛地毯
		TURF_DRAGONFLY = "巨大蝇蚋的皮能够防火。",			-- 龙鳞地板
		TURF_CHECKERFLOOR = "弈一局否？",				-- 棋盘地板
		TURF_MOSAIC_GREY = "好看的灰色石头地板。",		-- 灰色马赛克地面
		TURF_MOSAIC_RED = "好看的红色石头地板。",		-- 红色马赛克地面
		TURF_MOSAIC_BLUE = "好看的蓝色石头地板。",		-- "蓝色马赛克地面
		TURF_BEARD_RUG = "奇怪的行为艺术，像是年会做的事。",	-- 胡须地毯
		TURF_COTL_GOLD = "奢华的地板。",				-- 黄金地板
		TURF_COTL_BRICK = "坚固可靠的石砖地板。",	-- 砖地板" 制造描述
		TURF_METEOR = "一块月亮地面。",				-- 月球环形山地皮
		TURF_SHELLBEACH = "好看的贝壳。",			-- 贝壳海滩地皮"
		TURF_SANDY = "一种沙滩地皮。",				-- 沙滩地皮"（单机海难）
		TURF_MONKEY_GROUND = "被进行养护过的沙地。",	-- 月亮码头海滩地皮
		TURF_PEBBLEBEACH = "一块沙滩，满是石头。",		-- 岩石海滩地皮
		TURF_ROAD = "草草铺砌的石头路。",			-- 卵石路
		TURF_ROCKY = "一块荒石丛生的地皮。",		-- 岩石地皮
		TURF_SINKHOLE="湿哒哒的。",					-- 黏滑地皮
		TURF_CAVE="满是鸟类粪便。",					-- 鸟粪地皮
		TURF_FUNGUS="长满了蓝色的孢子。",					-- 菌类地皮(蓝色)
		TURF_FUNGUS_GREEN = "满是绿色孢子。",		-- 菌类地皮"(绿色)
		TURF_FUNGUS_RED = "满是红色孢子。",		-- 菌类地皮"(红色)
		TURF_FUNGUS_MOON = "它似乎变异了。",		-- 变异菌类地皮
		TURF_UNDERROCK="乱石嶙峋。",			-- 洞穴岩石地皮
		TURF_RUINSBRICK = "古老文明的遗产。",	-- 远古地面
		TURF_RUINSBRICK_GLOW = "只得形相近。",	-- 仿远古地面
		TURF_RUINSTILES = "古老文明的遗产。",	-- 远古瓷砖
		TURF_RUINSTILES_GLOW = "只得形相近。",	-- 仿远古瓷砖
		TURF_RUINSTRIM = "古老文明的遗产。",	-- 远古砖雕
		TURF_RUINSTRIM_GLOW = "只得形相近。",	-- 仿远古砖雕
		TURF_ARCHIVE = "远古的石刻。",			-- 远古石刻(档案馆地皮)
	------ 雕塑
		CHESSPIECE_PAWN = "我有同感。",		-- 物品名:"卒子雕塑"
		CHESSPIECE_MUSE = "它来自另一种象棋，是最强大的棋子，但终究也是棋子。",		-- 物品名:"女王雕塑"
		CHESSPIECE_FORMAL = "愈是“高贵”，愈是身不由己。",		-- 物品名:"国王雕塑"
		CHESSPIECE_HORNUCOPIA = "丰收靠的从来都是自食其力。",		-- 物品名:"丰饶角雕塑"
		CHESSPIECE_PIPE = "吸烟有害健康。",		-- 物品名:"泡泡烟斗雕塑"
		CHESSPIECE_BUTTERFLY = "蝴蝶是我，我即蝴蝶。",		-- 物品名:"月蛾雕塑"
		CHESSPIECE_ANCHOR = "征服大海总需要找到自己的锚点。",		-- 物品名:"锚雕塑"
		CHESSPIECE_MOON = "江畔何人初见月？江月何年初照人！",		-- 物品名:"“月亮” 雕塑"
		-- 三棋子雕塑/三基佬雕像
		-- 战车雕塑
		CHESSPIECE_ROOK =
		{
			GENERIC = "出车。",		-- 物品名:"战车雕塑"->默认
			STRUGGLE = "暗影的力量在雕塑里面汇聚。",		-- 物品名:"战车雕塑"->三基佬棋子晃动
		},
		-- 骑士雕塑
		CHESSPIECE_KNIGHT =
		{
			GENERIC = "走马。",		-- 物品名:"骑士雕塑"->默认
			STRUGGLE = "暗影的力量在雕塑里面汇聚。",		-- 物品名:"骑士雕塑"->三基佬棋子晃动
		},
		-- 主教雕塑
		CHESSPIECE_BISHOP =
		{
			GENERIC = "飞象。",		-- 物品名:"主教雕塑"->默认
			STRUGGLE = "暗影的力量在雕塑里面汇聚。",		-- 物品名:"主教雕塑"->三基佬棋子晃动
		},
		-- BOSS系列
		CHESSPIECE_MOOSEGOOSE ="高高在上的目光总会迎来报复。",		-- 物品名:"麋鹿鹅雕塑"
		CHESSPIECE_ANTLION = "前沙漠国王的雕塑。",		-- 物品名:"蚁狮雕塑"
		CHESSPIECE_BEARGER = "现在不需要你来帮忙砍树了。",		-- 物品名:"熊獾雕塑"
		CHESSPIECE_DEERCLOPS = "或许可以把那颗眼球放上去？",		-- 物品名:"独眼巨鹿雕塑"
		CHESSPIECE_DRAGONFLY = "看来你的热情耗尽了。",		-- 物品名:"龙蝇雕塑"

		CHESSPIECE_DAYWALKER = "江山易改，本性难移。",	-- 物品名:"噩梦猪人雕像"
		CHESSPIECE_MINOTAUR = "斗牛活动结束了。",		-- 物品名:"远古守护者雕塑"
		CHESSPIECE_STALKER = "至少现在它不会复活。",		-- 物品名:"远古织影者雕塑"
		CHESSPIECE_TOADSTOOL = "让它安静的呆着吧，至少不会让人昏昏欲睡。",		-- 物品名:"毒菌蟾蜍雕塑"
		
		CHESSPIECE_DEERCLOPS_MUTATED = "疯狂的月亮寄生产物。",	-- 物品名:"晶体独眼巨鹿雕塑"
		CHESSPIECE_WARG_MUTATED = "悲催的佩洛，死后也不得安宁。",	-- 物品名:"附身座狼雕塑"
		CHESSPIECE_BEARGER_MUTATED = "至少现在，你可以在这戒骄戒躁。",	-- 物品名:"装甲熊獾雕塑"
		CHESSPIECE_GUARDIANPHASE3 = "英雄的落幕。",		-- 物品名:"天体英雄雕塑"

		CHESSPIECE_EYEOFTERROR = "窥伺者只剩下冰冷的目光了。",		-- 物品名:"恐怖之眼雕塑"
		CHESSPIECE_TWINSOFTERROR = "成双成对也许不是什么好事。",		-- 物品名:"双子魔眼雕塑"
		CHESSPIECE_MALBATROSS = "海洋不只属于你。",		-- 物品名:"邪天翁雕塑"
		CHESSPIECE_CRABKING = "痴情的家伙，冥顽不顾。",		-- 物品名:"帝王蟹雕塑"
		CHESSPIECE_KLAUS = "强盗还是得到的应有的惩罚。",		-- 物品名:"克劳斯雕塑"
		CHESSPIECE_BEEQUEEN = "很有雕塑感。",		-- 物品名:"蜂王雕塑"
		CHESSPIECE_SHARKBOI = "至少它的靴子还挺有用。",	--物品名:"大霜鲨雕塑"
		-- 活动雕塑
		CHESSPIECE_CARRAT = "比赛胜者的纪念品。",		-- 物品名:"胡萝卜鼠雕塑"
		CHESSPIECE_BEEFALO = "这座雕塑很牛。",		-- 物品名:"皮弗娄牛雕塑"
		CHESSPIECE_KITCOON = "可爱。",		-- 物品名:"小浣猫雕塑"
		CHESSPIECE_CATCOON = "也许可以给它当猫爬架？",		-- 物品名:"浣猫雕塑"
		CHESSPIECE_MANRABBIT = "没有那么瘆人的卡特斯。",	-- 物品名:"兔人雕塑"
		CHESSPIECE_CLAYHOUND = "还不错。",		-- 物品名:"猎犬雕塑"
		CHESSPIECE_CLAYWARG = "可惜，喂不熟。",		-- 物品名:"座狼雕塑"
		CHESSPIECE_YOTD = "争渡！争渡！",	--物品名:"起点塔雕塑"
		CHESSPIECE_DEPTHWORM  = "比年的烂片还难看。",          -- 蠕虫年雕像
------ 自然生成----------------------------------
		TUMBLEWEED = "你从远方什么呢？",		-- 物品名:"风滚草"
		MESSAGEBOTTLE = "海洋没能把你的信送到目的地。",		-- 物品名:"瓶中信"
		MESSAGEBOTTLEEMPTY = "现在它空无一物。",		-- 物品名:"空瓶子"
		WETPAPER = "等它晒干吧。",		-- 物品名:"纸张"
		WETPOUCH = "看起来它有点勉强。",		-- 物品名:"起皱的包裹"
		SCRAPBOOK_PAGE = "一份佚失的图鉴。",	-- 物品名:"丢失的图鉴页面"
		-- 蓝图
		BLUEPRINT =
		{
			COMMON = "整理好的思路。",		-- 物品名:"蓝图"
			RARE = "少见的构思。",		-- 物品名:"蓝图"->罕见的
		},
		SKETCH = "一张雕像的图纸。空手可做不出来。",		-- 物品名:"{item}草图"
		-- 食谱图鉴
		COOKINGRECIPECARD =
		{
			GENERIC = "或许幺弟能看懂。",	-- 物品名:"{item}食谱"
		},
		-- 灰烬
		ASH =
		{
			GENERIC = "燃烧殆尽烬作灰。",		-- 物品名:"灰烬"->默认
			-- 单机版传送到冒险模式导致物品化灰专用
			REMAINS_GLOMMERFLOWER = "传送时，花被火焰吞噬了。",		-- 物品名:"灰烬"（单机专用）
			REMAINS_EYE_BONE = "传送时，眼骨被火焰吞噬了。",		-- 物品名:"灰烬"（单机专用）
			REMAINS_THINGIE = "不知道该怎么解释这个，罢了。",		-- 物品名:"灰烬"（单机专用）
		},
	------ 玩具
		TRINKET_1 = "奇特的小玩具，有些人对它印象很深，可惜被烤化了。", --Melted Marbles		-- 物品名:"熔化的弹珠"
		TRINKET_2 = "它并没有用来发声的笛膜。", --Fake Kazoo		-- 物品名:"假卡祖笛"
		TRINKET_3 = "迎刃而“解”。", --Gord's Knot		-- 物品名:"戈尔迪之结"
		TRINKET_4 = "饱经沧桑的花园摆饰，应该还有另一个。", --Gnome		-- 物品名:"地精爷爷"
		TRINKET_5 = "如若此后百年千年，来人漫步于繁星身侧，人们便要赞颂她的名。", --Toy Rocketship		-- 物品名:"迷你火箭"
		TRINKET_6 = "也许里面的铜还能导电。", --Frazzled Wires		-- 物品名:"烂电线"
		TRINKET_7 = "适合年与夕的玩具。", --Ball and Cup		-- 物品名:"杯子和球"
		TRINKET_8 = "为什么这里会有这个东西呢？", --Rubber Bung		-- 物品名:"硬化橡胶塞"
		TRINKET_9 = "也许它可以当玩偶的眼睛。", --Mismatched Buttons		-- 物品名:"不搭的纽扣"
		TRINKET_10 = "有些老家伙迟早会用得上。", --Dentures		-- 物品名:"二手假牙"
		TRINKET_11 = "看来你不像罗德岛的其他几个机器人那样智能。", --Lying Robot		-- 物品名:"机器人玩偶"
		TRINKET_12 = "闻起来一股腐臭味。", --Dessicated Tentacle		-- 物品名:"干瘪的触手"
		TRINKET_13 = "另一个花园摆饰，看起来是同一对。", --Gnomette		-- 物品名:"地精奶奶"
		TRINKET_14 = "岁月在它身上留下了痕迹。", --Leaky Teacup		-- 物品名:"漏水的茶杯"
		TRINKET_15 = "走马、边象。", --Pawn		-- 物品名:"白色主教"
		TRINKET_16 = "挺卒、中象。", --Pawn		-- 物品名:"黑色主教"
		TRINKET_17 = "这是勺子还是叉子呢？", --Bent Spork		-- 物品名:"弯曲的叉子"
		TRINKET_18 = "特洛伊木马。", --Trojan Horse		-- 物品名:"玩具木马"
		TRINKET_19 = "重心不稳，再怎么抽动它也还是没有效果。", --Unbalanced Top		-- 物品名:"失衡陀螺"
		TRINKET_20 = "不求人。", --Backscratcher		-- 物品名:"痒痒挠"
		TRINKET_21 = "用于搅拌的新兴厨具，最早出现在林贡斯，可现在已经不能用了。", --Egg Beater		-- 物品名:"破搅拌器"
		TRINKET_22 = "一团毛线球，菲林们对它没有任何抵抗力。", --Frayed Yarn		-- 物品名:"磨损的纱线"
		TRINKET_23 = "也许大哥的躯体在衰老后会用到它？", --Shoehorn		-- 物品名:"鞋拔子"
		TRINKET_24 = "看来它没有那么幸运。", --Lucky Cat Jar		-- 物品名:"幸运猫扎尔"
		TRINKET_25 = "像是年能做出来的发明。", --Air Unfreshener		-- 物品名:"臭气制造器"
		TRINKET_26 = "我是不会用它来盛酒的。", --Potato Cup		-- 物品名:"土豆杯"
		TRINKET_27 = "大炎孩子们的噩梦之一。", --Coat Hanger		-- 物品名:"钢丝衣架"
		TRINKET_28 = "在象棋里，虽然它最为强大，但也最不被信赖。", --Rook		-- 物品名:"白色战车"
		TRINKET_29 = "喜欢双车错吗？", --Rook		-- 物品名:"黑色战车"
		TRINKET_30 = "比那个雕塑好看多了。", --Knight		-- 物品名:"白色骑士"
		TRINKET_31 = "马后炮。", --Knight		-- 物品名:"黑色骑士"
		-- 万圣夜玩具
		TRINKET_32 = "有位来自萨米的埃拉菲亚会用它进行占卜。", --Cubic Zirconia Ball		-- 物品名:"立方氧化锆球"
		TRINKET_33 = "只是一个装饰品，但是品味不敢苟同。", --Spider Ring		-- 物品名:"蜘蛛指环"
		TRINKET_34 = "诅咒是另一种契机。", --Monkey Paw		-- 物品名:"猴爪"
		TRINKET_35 = "对于人类来说，长生不老只是一个诅咒。", --Empty Elixir		-- 物品名:"空的长生不老药"
		TRINKET_36 = "罗德岛上的几位血族可没有丢弃自己牙齿的习惯。", --Faux fangs		-- 物品名:"人造尖牙"
		TRINKET_37 = "那位拯救人类的圣子留下的传说可真不少。", --Broken Stake		-- 物品名:"断桩"
		TRINKET_38 = "昨夜边关犹灯火，眼前血海翻覆。", -- Binoculars Griftlands trinket		-- 物品名:"双筒望远镜"
		TRINKET_39 = "能为左手保暖。", -- Lone Glove Griftlands trinket		-- 物品名:"单只手套"
		TRINKET_40 = "背负世界的小家伙。", -- Snail Scale Griftlands trinket		-- 物品名:"蜗牛秤"
		TRINKET_41 = "不知道有什么用。", -- Goop Canister Hot Lava trinket		-- 物品名:"黏液罐"
		TRINKET_42 = "年，不要再给夕身后放这种东西了。", -- Toy Cobra Hot Lava trinket		-- 物品名:"玩具眼镜蛇"
		TRINKET_43 = "四驱沼泽小狗。", -- Crocodile Toy Hot Lava trinket		-- 物品名:"鳄鱼玩具"
		TRINKET_44 = "这株植物标本很难存活下去了。", -- Broken Terrarium ONI trinket		-- 物品名:"破碎的玻璃罐"
		TRINKET_45 = "似曾相识？", -- Odd Radio ONI trinket		-- 物品名:"奇怪的收音机"
		TRINKET_46 = "我的头发不会用其他东西烘干。", -- Hairdryer ONI trinket		-- 物品名:"损坏的吹风机"
		-- 小惊吓丢失的道具
		LOST_TOY_1  = "似乎是她生前的玩具？",		-- 物品名:"遗失的玻璃球"（小惊吓的玩具）
		LOST_TOY_2  = "似乎是她生前的玩具？",		-- 物品名:"多愁善感的卡祖笛"（小惊吓的玩具）
		LOST_TOY_7  = "似乎是她生前的玩具？",		-- 物品名:"珍视的抽线陀螺"（小惊吓的玩具）
		LOST_TOY_10 = "似乎是她生前的玩具？",		-- 物品名:"缺少的牙齿"（小惊吓的玩具）
		LOST_TOY_11 = "似乎是她生前的玩具？",		-- 物品名:"珍贵的玩具机器人"（小惊吓的玩具）
		LOST_TOY_14 = "似乎是她生前的玩具？",		-- 物品名:"妈妈最爱的茶杯"（小惊吓的玩具）
		LOST_TOY_18 = "似乎是她生前的玩具？",		-- 物品名:"宝贵的玩具木马"（小惊吓的玩具）
		LOST_TOY_19 = "似乎是她生前的玩具？",		-- 物品名:"最爱的陀螺"（小惊吓的玩具）
		LOST_TOY_42 = "似乎是她生前的玩具？",		-- 物品名:"装错的玩具眼镜蛇"（小惊吓的玩具）
		LOST_TOY_43 = "似乎是她生前的玩具？",		-- 物品名:"宠爱的鳄鱼玩具"（小惊吓的玩具）
---------- 活动内容 ----------------------------------------------------------------------------------------------------------
    -- 暴食 -------------------------------------------------------------------------------------------------------------
		-- 残破的房子
		QUAGMIRE_RUBBLE_HOUSE =
		{
			"兴亡皆苦。",		-- 物品名:"残破的房子"（暴食） 制造描述:未找到
			"一场肮脏的屠杀。",		-- 物品名:"残破的房子"（暴食） 制造描述:未找到
			"战火···劫掠···他们遭遇了一场屠杀。",		-- 物品名:"残破的房子"（暴食） 制造描述:未找到
		},
		QUAGMIRE_RUBBLE_CARRIAGE = "战火···劫掠···他们遭遇了一场屠杀。",	-- 物品名:"破烂的马车"（暴食）
		QUAGMIRE_RUBBLE_CLOCK = "战火···劫掠···他们遭遇了一场屠杀。",	-- 物品名:"砸烂的时钟"（暴食）
		QUAGMIRE_RUBBLE_CATHEDRAL = "战火···劫掠···他们遭遇了一场屠杀。",	-- 物品名:"残破的大教堂"（暴食）
		QUAGMIRE_RUBBLE_PUBDOOR = "战火···劫掠···他们遭遇了一场屠杀。",	-- 物品名:"残破的门"（暴食）
		QUAGMIRE_RUBBLE_ROOF = "战火···劫掠···他们遭遇了一场屠杀。",	-- 物品名:"残破的屋顶"（暴食）
		QUAGMIRE_RUBBLE_CLOCKTOWER = "战火···劫掠···他们遭遇了一场屠杀。",	-- 物品名:"残破的钟楼"（暴食）
		QUAGMIRE_RUBBLE_BIKE = "战火···劫掠···他们遭遇了一场屠杀。",	-- 物品名:"损毁的自行车"（暴食）

		QUAGMIRE_RUBBLE_CHIMNEY = "灰飞烟灭。",	-- 物品名:"残破的烟囱"（暴食）
		QUAGMIRE_RUBBLE_CHIMNEY2 = "灰飞烟灭。",	-- 物品名:"残破的烟囱"（暴食）
		QUAGMIRE_MERMHOUSE = "丑陋的鱼人屋。",	-- 物品名:"鱼人屋"（暴食）
		QUAGMIRE_SWAMPIG_HOUSE = "为什么会变成这样？",	-- 物品名:"破烂的猪屋"（暴食）
		QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "被摧毁的猪屋。",	-- 物品名:"房子碎石"（暴食）
		-- 饕餮祭坛
		QUAGMIRE_ALTAR =
		{
			GENERIC = "看来它饿了。",		-- 物品名:"饕餮祭坛"（暴食）->默认
			FULL = "进食，消化，无穷无尽。",		-- 物品名:"饕餮祭坛"（暴食）->满了
		},	
		QUAGMIRE_ALTAR_STATUE1 = "一个老旧雕塑。",	-- 物品名:"饥饿之兽"（暴食）
		QUAGMIRE_PARK_FOUNTAIN = "看起来很古老了。",	-- 物品名:"喷泉"（暴食）

		QUAGMIRE_HOE = "耕者忘其犁，锄者忘其锄",	-- 物品名:"锄头"（暴食）

		QUAGMIRE_TURNIP = "巨大的萝卜，可惜将会成为饕餮的盛宴。",	-- 物品名:"大萝卜"（暴食）
		QUAGMIRE_TURNIP_COOKED = "味道还可以。",	-- 物品名:"烤大萝卜"（暴食）
		QUAGMIRE_TURNIP_SEEDS = "古怪的大萝卜种子。",	-- 物品名:"圆形种子"（暴食）

		QUAGMIRE_GARLIC = "口气清新剂。",	-- 物品名:"大蒜"（暴食）
		QUAGMIRE_GARLIC_COOKED = "焦黄色。",	-- 物品名:"烤大蒜"（暴食）
		QUAGMIRE_GARLIC_SEEDS = "古怪的大蒜种子。",	-- 物品名:"种子荚"（暴食）

		QUAGMIRE_ONION = "切洋葱不要揉眼睛。",	-- 物品名:"洋葱"（暴食）
		QUAGMIRE_ONION_COOKED = "一次成功的化学反应。",	-- 物品名:"烤洋葱"（暴食）
		QUAGMIRE_ONION_SEEDS = "古怪的洋葱的种子。",	-- 物品名:"尖形种子"（暴食）

		QUAGMIRE_POTATO = "高产的粮食。",	-- 物品名:"土豆"（暴食）
		QUAGMIRE_POTATO_COOKED = "看着还可以。",	-- 物品名:"烤土豆"（暴食）
		QUAGMIRE_POTATO_SEEDS = "古怪的土豆种子。",	-- 物品名:"毛茸茸的种子"（暴食）

		QUAGMIRE_TOMATO = "饱满多汁。",	-- 物品名:"番茄"（暴食）
		QUAGMIRE_TOMATO_COOKED = "也许该打个鸡蛋。",	-- 物品名:"烤番茄"（暴食）
		QUAGMIRE_TOMATO_SEEDS = "古怪的番茄种子。",	-- 物品名:"带刺的种子"（暴食）

		QUAGMIRE_FLOUR = "可以烘焙了。",	-- 物品名:"面粉"（暴食）
		QUAGMIRE_WHEAT = "它看起来是颗粒状的。",	-- 物品名:"小麦"（暴食）
		QUAGMIRE_WHEAT_SEEDS = "一把古怪的种子。",	-- 物品名:"蓝色种子"（暴食）
		--NOTE: raw/cooked carrot uses regular carrot strings
		QUAGMIRE_CARROT_SEEDS = "古怪的胡萝卜种子。",	-- 物品名:"椭圆形种子"（暴食）

		QUAGMIRE_ROTTEN_CROP = "祭祀时可不能用这种食物。",	-- 物品名:"腐烂的农作物"（暴食）

		QUAGMIRE_SALMON = "很有活力。",	-- 物品名:"三文鱼"（暴食）
		QUAGMIRE_SALMON_COOKED = "肥瘦相间。",	-- 物品名:"熟三文鱼"（暴食）
		QUAGMIRE_CRABMEAT = "得快点蒸熟它。",	-- 物品名:"蟹肉"（暴食）
		QUAGMIRE_CRABMEAT_COOKED = "第一个吃螃蟹",	-- 物品名:"熟蟹肉"（暴食）
		-- 糖木树
		QUAGMIRE_SUGARWOODTREE =
		{
			GENERIC = "满满的枫糖浆。",		-- 物品名:"糖木树"（暴食）->默认
			STUMP = "被砍倒了。",		-- 物品名:"糖木树"（暴食）->暴食模式糖木树只剩树桩了
			TAPPED_EMPTY = "也许得等一段时间。",		-- 物品名:"糖木树"（暴食）->暴食模式糖木树空了
			TAPPED_READY = "香味四溢。",		-- 物品名:"糖木树"（暴食）->暴食模式糖木树好了
			TAPPED_BUGS = "这群蚂蚁也想分一杯羹。",		-- 物品名:"糖木树"（暴食）->暴食模式糖木树上有蚂蚁
			WOUNDED = "它看上去病了。",		-- 物品名:"糖木树"（暴食）->暴食糖木树生病了
		},
		-- 带斑点的小灌木
		QUAGMIRE_SPOTSPICE_SHRUB =
		{
			GENERIC = "能摘点带香味的果实。",		-- 物品名:"带斑点的小灌木"（暴食）->默认
			PICKED = "已经采摘完了。",		-- 物品名:"带斑点的小灌木"（暴食）->被采完了
		},
		QUAGMIRE_SPOTSPICE_SPRIG = "闻起来很香。",	-- 物品名:"带斑点的小枝"（暴食）
		QUAGMIRE_SPOTSPICE_GROUND = "正宗香料。",	-- 物品名:"斑点香料"（暴食）
		QUAGMIRE_SAPBUCKET = "可以用它采集树液。",	-- 物品名:"树液采集工具包"（暴食）
		QUAGMIRE_SAP = "甜甜的。",	-- 物品名:"汁液"（暴食）
		-- 盐架(建筑)
		QUAGMIRE_SALT_RACK =
		{
			READY = "结绳积盐。",		-- 物品名:"盐架"（暴食）->准备好的 满的
			GENERIC = "盐会累计在上面。",		-- 物品名:"盐架"（暴食）->默认
		},

		QUAGMIRE_POND_SALT = "一眼咸水泉。",	-- 物品名:"盐池"（暴食）
		QUAGMIRE_SALT_RACK_ITEM = "古法取盐。",	-- 物品名:"盐架"（暴食）
		QUAGMIRE_SALTROCK = "盐。",	-- 物品名:"盐晶"（暴食）
		QUAGMIRE_SALT = "满满的盐。",	-- 物品名:"盐"（暴食）

		QUAGMIRE_KEY = "也许能打开什么。",	-- 物品名:"钥匙"（暴食）
		QUAGMIRE_KEY_PARK = "铁质的钥匙。",	-- 物品名:"铁钥匙"（暴食）

		QUAGMIRE_PORTAL_KEY = "自远古遗落下来的钥匙。",	-- 物品名:"远古钥匙"（暴食）
		QUAGMIRE_PORTAL = "死胡同。",	-- 物品名:"远古大门"（暴食）
		
		-- 保险箱
		QUAGMIRE_SAFE =
		{
			GENERIC = "保护珍贵物品。",		-- 物品名:"保险箱"（暴食）->默认
			LOCKED = "必须要有专门的钥匙",		-- 物品名:"保险箱"（暴食）->锁住了
		},
		-- 蘑菇(作物)
		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "不知道能不能吃。",		-- 物品名:"蘑菇"（暴食）->默认
			PICKED = "它的根还在。",		-- 物品名:"蘑菇"（暴食）->被采完了
		},
		QUAGMIRE_MUSHROOMS = "看起来可食用。",	-- 物品名:"蘑菇"（暴食）
		QUAGMIRE_MEALINGSTONE = "磨盘战地人犹识，磷火常同日色鲜。",	-- 物品名:"碾磨石"（暴食）
		QUAGMIRE_PEBBLECRAB = "它的壳有点碍事。",	-- 物品名:"石蟹"（暴食）
		-- 沼泽猪长老
		QUAGMIRE_SWAMPIGELDER =
		{
			GENERIC = "看来他就是族长了。",		-- 物品名:"沼泽猪长老"（暴食）->默认
			SLEEPING = "希望你能做个好梦。",		-- 物品名:"沼泽猪长老"（暴食）->睡着了
		},
		QUAGMIRE_SWAMPIG = "它的毛很多。",	-- 物品名:"沼泽猪"（暴食）
		-- 饕餮祭品
		QUAGMIRE_FOOD =
		{
			GENERIC = "我应该把它献祭在饕餮祭坛上。",		-- 物品名:未找到（暴食）
			MISMATCH = "它不喜欢这个。",		-- 物品名:未找到（暴食）
			MATCH = "看起来有效。",		-- 物品名:未找到（暴食）
			MATCH_BUT_SNACK = "还好。",		-- 物品名:未找到（暴食）
		},
		-- 铁门
		QUAGMIRE_PARK_GATE =
		{
			GENERIC = "没钥匙不行。",		-- 物品名:"铁门"（暴食）->默认
			LOCKED = "锁得牢牢的。",		-- 物品名:"铁门"（暴食）->锁住了
		},
		-- 鸽子
		QUAGMIRE_PIGEON =
		{
			DEAD = "看来它再也不会放鸽子了。",		-- 物品名:"鸽子"（暴食）->死了 制造描述:"这是一只完整的活鸽。"
			GENERIC = "羽翼丰满。",		-- 物品名:"鸽子"（暴食）->默认 制造描述:"这是一只完整的活鸽。"
			SLEEPING = "睡吧。",		-- 物品名:"鸽子"（暴食）->睡着了 制造描述:"这是一只完整的活鸽。"
		},
		QUAGMIRE_LAMP_POST = "万家灯火。",	-- 物品名:"街灯"（暴食）

		QUAGMIRE_BEEFALO = "自然死亡。",	-- 物品名:"老皮弗娄牛"（暴食）
		QUAGMIRE_SLAUGHTERTOOL = "专业屠宰工具。",	-- 物品名:"屠宰工具"（暴食）

		QUAGMIRE_SAPLING = "得等它长回来了。",	-- 物品名:"树苗"（暴食）
		QUAGMIRE_BERRYBUSH = "浆果已经没了。",	-- 物品名:"浆果丛"（暴食）

		QUAGMIRE_ALTAR_STATUE2 = "看来你还是很贪心啊。",	-- 物品名:"饥饿之兽"（暴食）
		QUAGMIRE_ALTAR_QUEEN = "一座有纪念意义的纪念碑。",	-- 物品名:"女王野兽"（暴食）
		QUAGMIRE_ALTAR_BOLLARD = " 这根足够了。",	-- 物品名:"柱子"（暴食）
		QUAGMIRE_ALTAR_IVY = "有点粘人。",	-- 物品名:"常春藤"（暴食）

		QUAGMIRE_LAMP_SHORT = "亮起来。",	-- 物品名:"小街灯"（暴食）
		QUAGMIRE_FERN = "富含维生素。",	-- 物品名:"蕨类植物"（暴食）
		QUAGMIRE_FOLIAGE_COOKED = "就当煮茶了。",	-- 物品名:"熟叶子"（暴食）
		QUAGMIRE_COIN1 = "至少能买点东西。",	-- 物品名:"旧硬币"（暴食）
		QUAGMIRE_COIN2 = "会有人想要它的。",	-- 物品名:"蓝宝石徽章"（暴食）
		QUAGMIRE_COIN3 = "似乎有价值。",	-- 物品名:"红色马克硬币"（暴食）
		QUAGMIRE_COIN4 = "可以重新打开大门。",	-- 物品名:"饕餮的惠赠"（暴食）
		QUAGMIRE_GOATMILK = "挺好的。",	-- 物品名:"羊奶"（暴食）
		QUAGMIRE_SYRUP = "加点甜味。",	-- 物品名:"糖浆"（暴食）
		QUAGMIRE_SAP_SPOILED = "还不如把它扔进火里。",	-- 物品名:"毁掉的汁液"（暴食）
		QUAGMIRE_SEEDPACKET = "也许该种点作物。",	-- 物品名:"种子包"（暴食）

		QUAGMIRE_POT = "可以装更多配料。",	-- 物品名:"大锅"（暴食）
		QUAGMIRE_POT_SMALL = "开锅吧。",	-- 物品名:"锅"（暴食）
		QUAGMIRE_POT_SYRUP = "炒点糖色。",	-- 物品名:"糖浆锅"（暴食）
		QUAGMIRE_POT_HANGER = "它带有挂钩。",	-- 物品名:"挂锅装置"（暴食）
		QUAGMIRE_POT_HANGER_ITEM = "用来悬挂炊具。",	-- 物品名:"挂锅装置"（暴食）
		QUAGMIRE_GRILL = "该到哪里放置呢。",	-- 物品名:"大烤架"（暴食）
		QUAGMIRE_GRILL_ITEM = "“烤”问利器。",	-- 物品名:"大烤架"（暴食）
		QUAGMIRE_GRILL_SMALL = "烤出好味道。",	-- 物品名:"小烤架"（暴食）
		QUAGMIRE_GRILL_SMALL_ITEM = "用来烤小块肉。",	-- 物品名:"小烤架"（暴食）
		QUAGMIRE_OVEN = "得加点碳。",	-- 物品名:"烤箱"（暴食）
		QUAGMIRE_OVEN_ITEM = "烘烤厨具。",	-- 物品名:"烤箱"（暴食）
		QUAGMIRE_CASSEROLEDISH = "来做大杂烩。",	-- 物品名:"大法国砂锅"（暴食）
		QUAGMIRE_CASSEROLEDISH_SMALL = "可以做各种杂七杂八的小菜。",	-- 物品名:"小法国砂锅"（暴食）
		QUAGMIRE_PLATE_SILVER = "镀银的盘子。",	-- 物品名:"银盘"（暴食）
		QUAGMIRE_BOWL_SILVER = "一只明亮的碗。",	-- 物品名:"银碗"（暴食）
		QUAGMIRE_CRATE = "厨房用具。",	-- 物品名:"大型烤架套装、烤架套装、烤箱套装、锅具套装"（暴食）

		QUAGMIRE_MERM_CART1 = "里面有什么吗？", --sammy's wagon	-- 物品名:"萨米的货车"（暴食）
		QUAGMIRE_MERM_CART2 = "有些东西我用得上。", --pipton's cart	-- 物品名:"皮普顿的马车"（暴食）
		QUAGMIRE_PARK_ANGEL = "接招！",	-- 物品名:"饕餮敬拜者"（暴食）
		QUAGMIRE_PARK_ANGEL2 = "栩栩如生。",	-- 物品名:"饕餮敬拜者"（暴食）
		QUAGMIRE_PARK_URN = "尘归尘。",	-- 物品名:"骨灰瓮"（暴食）
		QUAGMIRE_PARK_OBELISK = "一座有纪念意义的纪念碑。",	-- 物品名:"石柱"（暴食）
		
		QUAGMIRE_PARKSPIKE = "能有效阻挡怪物的“铁钉”。",	-- 物品名:"铁栅栏"（暴食）
		QUAGMIRE_CRABTRAP = "螃蟹陷阱。",	-- 物品名:"螃蟹陷阱"（暴食）
		QUAGMIRE_TRADER_MERM = "以物换物。",	-- 物品名:"萨米\n头脑清晰的泥沼鱼人"（暴食）
		QUAGMIRE_TRADER_MERM2 = "已缴费。",	-- 物品名:"皮普顿\n清醒的泥沼鱼人"（暴食）

		QUAGMIRE_GOATMUM = "。。。。。。",	-- 物品名:"玛姆茜"（暴食）
		QUAGMIRE_GOATKID = "小山羊。",	-- 物品名:"比利"（暴食）

		QUAGMIRE_FOOD_BURNT = "或许不该这么浪费宝贵的粮食了。",	-- 物品名:"烧焦的食物"（暴食）
	-- 熔炉 -------------------------------------------------------------------------------------------------------------
		-- 远古大门
		LAVAARENA_PORTAL =
		{
			ON = "又一处战场。",		-- 物品名:"远古大门"（熔炉）->开启
			GENERIC = "也许得做点什么？",		-- 物品名:"远古大门"（熔炉）->默认
		},
		LAVAARENA_BOARLORD = "看来他就是首领。",	-- 物品名:"战斗大师普格纳"（熔炉）
		-- 怪物
		BOARON = "战斗猪人。",		-- 物品名:"战猪"（熔炉）
		PEGHOOK = "也许能拿来做药酒？",		-- 物品名:"蝎子"（熔炉）
		TRAILS = "头脑简单。",		-- 物品名:"野猪猩"（熔炉）
		TURTILLUS = "直接打它的龟壳可不是一个好主意。",		-- 物品名:"坦克龟"（熔炉）
		SNAPPER = "沼泽小狗。",		-- 物品名:"鳄鱼指挥官"（熔炉）
		BOARRIOR = "只是看起来高大威猛。",		-- 物品名:"大熔炉猪战士"（熔炉）->大熔炉猪战士
		RHINODRILL = "上阵亲兄弟。",		-- 物品名:"后扣帽犀牛兄弟"（熔炉）
		BEETLETAUR = "它的另一只眼睛呢？",		-- 物品名:"地狱独眼巨猪"（熔炉）
		-- 武器
		LAVAARENA_LUCY = "我的飞斧技术并不好。",	-- 物品名:"暴怒的露西"（熔炉）
		HEALINGSTAFF = "脑啡肽。",		-- 物品名:"生命魔杖"（熔炉）
		FIREBALLSTAFF = "天坠之火。",		-- 物品名:"地狱魔杖"（熔炉）
		HAMMER_MJOLNIR = "跃空碎颅击。",		-- 物品名:"锻锤"（熔炉）
		SPEAR_GUNGNIR = "刺穿。",		-- 物品名:"尖齿矛"（熔炉）
		BLOWDART_LAVA = "可以快速射击。",		-- 物品名:"吹箭"（熔炉）
		BLOWDART_LAVA2 = "酒火风暴。",		-- 物品名:"熔化吹箭"（熔炉）
		WEBBER_SPIDER_MINION = "不稳定结盟。",		-- 物品名:"蜘蛛宝宝"（熔炉）
		LAVAARENA_BERNIE = "能利用他进行干扰。",	-- 物品名:"伯尼"（熔炉）
		LAVAARENA_ELEMENTAL = "熔岩巨兽。",	-- 物品名:"岩浆傀儡"（熔炉）
		BOOK_FOSSIL = "某种炼金术。",		-- 物品名:"石化之书"（熔炉）
		SPEAR_LANCE = "大荒星陨。",		-- 物品名:"螺旋矛"（熔炉）
		BOOK_ELEMENTAL = "汇聚火焰的力量。",		-- 物品名:"召唤之书"（熔炉）
		-- 护甲
		LAVAARENA_ARMORLIGHT = "轻巧，不耐用。",	-- 物品名:"芦苇束腰外衣"（熔炉）
		LAVAARENA_ARMORLIGHTSPEED = "很轻巧。",	-- 物品名:"羽饰芦苇外衣"（熔炉）
		LAVAARENA_ARMORMEDIUM = "还凑合。",	-- 物品名:"木质护甲"（熔炉）
		LAVAARENA_ARMORMEDIUMDAMAGER = "猛攻。",	-- 物品名:"锯齿木甲"（熔炉）
		LAVAARENA_ARMORMEDIUMRECHARGER = "很丝滑哦。",	-- 物品名:"丝带木甲"（熔炉）
		LAVAARENA_ARMORHEAVY = "有点重。",	-- 物品名:"石头板甲"（熔炉）
		LAVAARENA_ARMOREXTRAHEAVY = "极好。",	-- 物品名:"坚固的石质护甲"（熔炉）
		LAVAARENA_ARMOR_HP = "看起来特别坚固",	-- 物品名:"华丽巨齿铠甲、华丽坚固盔甲、华丽低语盔甲、华丽丝带盔甲"（熔炉）
		-- 头盔
		LAVAARENA_FEATHERCROWNHAT = "更快的速度。",	-- 物品名:"羽毛头环"（熔炉）
		LAVAARENA_HEALINGFLOWERHAT = "会增幅治愈魔法。",	-- 物品名:"花饰头带"（熔炉）
		LAVAARENA_LIGHTDAMAGERHAT = "猛攻。",	-- 物品名:"带刺头盔"（熔炉）
		LAVAARENA_STRONGDAMAGERHAT = "进军。",	-- 物品名:"司夜女神头盔"（熔炉）
		LAVAARENA_TIARAFLOWERPETALSHAT = "能大幅增强治愈力。",	-- 物品名:"编织花环"（熔炉）
		LAVAARENA_EYECIRCLETHAT = "顶好的。",	-- 物品名:"洞察皇冠"（熔炉）
		LAVAARENA_RECHARGERHAT = "神器能量焦点。",	-- 物品名:"水晶头饰"（熔炉）
		LAVAARENA_HEALINGGARLANDHAT = "很不错。",	-- 物品名:"绽放花环"（熔炉）
		LAVAARENA_CROWNDAMAGERHAT = "更加专注于战斗。",	-- 物品名:"华丽的司夜女神头盔"（熔炉）
		-- 其他
		LAVAARENA_FIREBOMB = "借助火焰的力量。",	-- 物品名:"炉火晶石"（熔炉）
		LAVAARENA_HEAVYBLADE = "沉重的阔剑。",	-- 物品名:"铁匠的刀刃"（熔炉）
		LAVAARENA_KEYHOLE = "钥匙似乎遗失了。",	-- 物品名:"远古锚"（熔炉）
		LAVAARENA_KEYHOLE_FULL = "应该可以了。",	-- 物品名:"远古锚"（熔炉）
		LAVAARENA_BATTLESTANDARD = "斩将夺旗！",	-- 物品名:"战旗"（熔炉）
		LAVAARENA_SPAWNER = "还有什么，尽管来。",	-- 物品名:"熔炉传送门"（熔炉）
	-- 鸦年华 	-----------------------------------------------------------------------------------------------------------
		CARNIVAL_HOST = "活动的主理人。",		-- 物品名:"良羽鸦"
		CARNIVAL_CROWKID = "活动需要的观众。",		-- 物品名:"小乌鸦"
		CARNIVAL_GAMETOKEN = "专属的活动货币。",		-- 物品名:"鸦年华代币" 制造描述:"购买代币，玩游戏，赢取奖品！"
		-- 奖票
		CARNIVAL_PRIZETICKET =
		{
			GENERIC = "赢得的奖励。",		-- 物品名:"奖票"->默认
			GENERIC_SMALLSTACK = "就当是运气好罢了。",		-- 物品名:"奖票"->一小堆
			GENERIC_LARGESTACK = "诶呀，还不少嘛。",		-- 物品名:"奖票"->一大堆
		},
		-- 鸟鸟吃虫虫
		CARNIVALGAME_FEEDCHICKS_KIT = "嘉年华快乐。",		-- 物品名:"鸟鸟吃虫虫套装" 制造描述:"小鸟吃虫！"
		CARNIVALGAME_FEEDCHICKS_STATION =
		{
			GENERIC = "投币游玩。",		-- 物品名:"鸟鸟吃虫虫"->默认
			PLAYING = "看起来有趣喔！",		-- 物品名:"鸟鸟吃虫虫"->游戏中
		},
		CARNIVALGAME_FEEDCHICKS_NEST = "这是一扇小活门。",		-- 物品名:"饥饿乌鸦"		
		CARNIVALGAME_FEEDCHICKS_FOOD = "emmmm...",		-- 物品名:"蛴螬"
		-- 篮中蛋
		CARNIVALGAME_MEMORY_KIT = "嘉年华快乐。",		-- 物品名:"篮中蛋套装" 制造描述:"在你的蛋孵化前数清楚数量。"
		CARNIVALGAME_MEMORY_STATION =
		{
			GENERIC = "投币游玩。",		-- 物品名:"篮中蛋"->默认
			PLAYING = "试试我的准头。",		-- 物品名:"篮中蛋"->游戏中
		},
		-- 蛋篮
		CARNIVALGAME_MEMORY_CARD =
		{
			GENERIC = "这是一扇小活门。",		-- 物品名:"蛋篮"->默认
			PLAYING = "是它吗？",		-- 物品名:"蛋篮"->游戏中
		},
		-- 追蛋
		CARNIVALGAME_HERDING_KIT = "嘉年华快乐。",		-- 物品名:"追蛋套裝" 制造描述:"追回失控的蛋。"
		CARNIVALGAME_HERDING_STATION =
		{
			GENERIC = "投币游玩。",		-- 物品名:"追蛋"->默认
			PLAYING = "我应该追上去。",		-- 物品名:"追蛋"->游戏中
		},
		CARNIVALGAME_HERDING_CHICK = "回来！",		-- 物品名:"追蛋"
		-- 保卫鸟巢
		CARNIVALGAME_SHOOTING_KIT = "嘉年华快乐。",	-- 物品名:"保卫鸟巢套装"
		CARNIVALGAME_SHOOTING_STATION =
		{
			GENERIC = "投币游玩。",	-- 物品名:"保卫鸟巢"->默认
			PLAYING = "瞄准那些害虫。",	-- 物品名:"保卫鸟巢"->游戏中
		},
		-- 射击靶
		CARNIVALGAME_SHOOTING_TARGET =
		{
			GENERIC = "这是一扇小活门。",	-- 物品名:"射击靶"->默认
			PLAYING = "让我试试。",	-- 物品名:"射击靶"->游戏中
		},
		-- 开火按钮
		CARNIVALGAME_SHOOTING_BUTTON =
		{
			GENERIC = "投币游玩。",	-- 物品名:"按钮"->默认
			PLAYING = "会发生什么呢？",	-- 物品名:"按钮"->游戏中
		},
		-- 布谷鸟转盘
		CARNIVALGAME_WHEELSPIN_KIT = "嘉年华快乐。",	-- 物品名:"布谷鸟转盘套装"
		CARNIVALGAME_WHEELSPIN_STATION =
		{
			GENERIC = "投币游玩。",	-- 物品名:"布谷鸟转盘"->默认
			PLAYING = "装起来。",	-- 物品名:"布谷鸟转盘"->游戏中
		},
		-- 鸟房落球游戏
		CARNIVALGAME_PUCKDROP_KIT = "嘉年华快乐。",	-- 物品名:"鸟房落球套装"
		CARNIVALGAME_PUCKDROP_STATION =
		{
			GENERIC = "投币游玩。",	-- 物品名:"鸟房落球"->默认
			PLAYING = "也许得找好技巧。",	-- 物品名:"鸟房落球"->游戏中
		},
		-- 奖品摊位(建筑)
		CARNIVAL_PRIZEBOOTH_KIT = "奖票兑换处。",		-- 物品名:"奖品摊位套装" 制造描述:"看看有什么奖品。"
		CARNIVAL_PRIZEBOOTH =
		{
			GENERIC = "有些我感兴趣的东西。",		-- 物品名:"奖品摊位"->默认
		},
		-- 玩具大炮
		CARNIVALCANNON_KIT = "礼炮·强制追思。",		-- 物品名:"玩具大炮套装"
		CARNIVALCANNON =
		{
			GENERIC = "满满的礼物。",		-- 物品名:"玩具大炮"->就绪
			COOLDOWN = "得等一下。",		-- 物品名:"玩具大炮"->冷却
		},
		-- 鸦年华树苗
		CARNIVAL_PLAZA_KIT = "不可或缺。",		-- 物品名:"鸦年华树苗" 制造描述:"鸦年华不可或缺的中间物件。"
		CARNIVAL_PLAZA =
		{
			GENERIC = "也许得装饰一下才能开始嘉年华。",		-- 物品名:"鸦年华树"->默认
			LEVEL_2 = "还缺少一些东西。",		-- 物品名:"鸦年华树"->升级
			LEVEL_3 = "欢乐时刻。",		-- 物品名:"鸦年华树"->最高级
		},

		CARNIVALDECOR_EGGRIDE_KIT = "迷你的游乐场。",		-- 物品名:"摆动玩具套装"
		CARNIVALDECOR_EGGRIDE = "该好好享受短暂的欢乐了。",		-- 物品名:"摆动玩具"

		CARNIVALDECOR_LAMP_KIT = "照亮狂欢之夜。",		-- 物品名:"盛夏夜灯套装" 制造描述:"夏夜的梦幻之光。"
		CARNIVALDECOR_LAMP = "精致的小夜灯。",		-- 物品名:"盛夏夜灯"
		CARNIVALDECOR_PLANT_KIT = "一颗装饰小树。",		-- 物品名:"微型树套装" 制造描述:"一小块鸦年华。"
		CARNIVALDECOR_PLANT = "确实给够小，但也带来了嘉年华的氛围。",		-- 物品名:"微型树"
		CARNIVALDECOR_BANNER_KIT = "能制造一些气氛。",	-- 物品名:"光线捕捉器套装"
		CARNIVALDECOR_BANNER = "亮晶晶的。",	-- 物品名:"光线捕捉器"
		-- 神秘盒子
		CARNIVALDECOR_FIGURE =
		{
			RARE = "最为独特的头奖。",		-- 物品名:"稀有鸦年华小雕像"
			UNCOMMON = "比较特殊的款式。",		-- 物品名:"特别鸦年华小雕像"
			GENERIC = "最普通的款式。",		-- 物品名:"普通鸦年华小雕像"
		},
		CARNIVALDECOR_FIGURE_KIT = "开盲盒了。",		-- 物品名:"神秘盒子" 制造描述:"这个神秘的绿盒子里会有什么呢？"
		CARNIVALDECOR_FIGURE_KIT_SEASON2 = "开盲盒了。",	-- 物品名:"金色神秘盒子" 制造描述:"这个神秘的金盒子里会有什么呢？"

		CARNIVAL_BALL = "有“球”必应。", --unimplemented		-- 物品名:"发光红球" 制造描述:"保证你有球必应！"
		CARNIVAL_SEEDPACKET = "能开出什么种子呢？",		-- 物品名:"种子包" 制造描述:"鸦年华最爱的香脆小吃。"
		CARNIVALFOOD_CORNTEA = "玉米碎。",		-- 物品名:"玉米泥" 制造描述:"出乎意料的清爽！"

		CARNIVAL_VEST_A = "吵吵闹闹红色围巾。",		-- 物品名:"叽叽喳喳围巾" 制造描述:"用捡来的树叶做成的异想天开的围巾。"
		CARNIVAL_VEST_B = "熙熙攘攘的树叶斗篷。",		-- 物品名:"叽叽喳喳斗篷" 制造描述:"这东西确实值得称道。"
		CARNIVAL_VEST_C = "精致的枯叶披肩。",		-- 物品名:"叽叽喳喳小披肩" 制造描述:"鸦年华游客的必备小披肩。"
	-- 万圣节 ------------------------------------------------------------------------------------------------------------
		MADSCIENCE_LAB = "有趣的东西，让我看看，这些人类会有多疯狂。",		-- 物品名:"疯狂科学家实验室" 制造描述:"疯狂实验无极限。唯独神智有极限。"
		-- 恐惧克服
		HALLOWEENPOTION_BRAVERY_SMALL = "只能提取这么点了。",-- 减轻恐惧的药液
		HALLOWEENPOTION_BRAVERY_LARGE = "直面恐惧才能知晓答案。",     -- 终止恐惧的药液
		-- 乐观
		HALLOWEENPOTION_HEALTH_SMALL = "只能提取这么点了。",-- 瓶装乐观混合剂
		HALLOWEENPOTION_HEALTH_LARGE = "良好的心态有助于恢复。",     -- 壶装乐观混合剂
		-- 勇气
		HALLOWEENPOTION_SANITY_SMALL = "新手只能提取这么点了。",-- 少许刚毅勇气
		HALLOWEENPOTION_SANITY_LARGE = "令人英勇无畏。",       -- 杯装刚毅勇气
		-- 硫化液
		HALLOWEENPOTION_EMBERS = "诡异的色泽。",-- 石灰硫化晶体
		HALLOWEENPOTION_SPARKS = "奇妙的色泽。",-- 硝化硫酸晶体
		-- 月亮精华液
		HALLOWEENPOTION_MOON = "月亮并没有没有看起来那么美丽。",		-- 物品名:"月亮精华液"	
		-- 完全正常的树
		LIVINGTREE_ROOT = "被遗漏的小树苗，伐木工不会在乎。",		-- 物品名:"完全正常的树根"
		LIVINGTREE_SAPLING = "你要用尖啸吓走我吗？",		-- 物品名:"完全正常的树苗"
		-- 南瓜帽
		PUMPKINHAT =
		{
			GENERIC  = "看起来怪怪的。", -- 已雕刻
			UNCARVED = "应该雕刻点什么呢。", -- 未雕刻
		},
		CANDYBAG = "送给小孩子的糖果袋。",		-- 物品名:"糖果袋" 制造描述:"只带万圣夜好吃的东西。
		-- 糖果
		HALLOWEENCANDY_1 = "裹了糖浆的苹果，吃多了会蛀牙。",		-- 物品名:"糖果苹果"
		HALLOWEENCANDY_2 = "小糖果，黍在罗德岛会做一些分给小朋友吃。",		-- 物品名:"糖果玉米"
		HALLOWEENCANDY_3 = "我记得大荒城的农业天师有改良过的品种，更甜更糯。",		-- 物品名:"不太甜的玉米"
		HALLOWEENCANDY_4 = "甘草做成的糖果。",		-- 物品名:"粘液蜘蛛"
		HALLOWEENCANDY_5 = "恶趣味的包装。",		-- 物品名:"浣猫糖果"
		HALLOWEENCANDY_6 = "莫不是在消遣我？",		-- 物品名:"\"葡萄干\""
		HALLOWEENCANDY_7 = "我更喜欢葡萄美酒。",		-- 物品名:"葡萄干"
		HALLOWEENCANDY_8 = "符合节日特色的糖果。",		-- 物品名:"鬼魂棒棒糖"
		HALLOWEENCANDY_9 = "有点黏牙。",		-- 物品名:"果冻虫"
		HALLOWEENCANDY_10 = "抛开外观，味道还不错。",		-- 物品名:"触须棒棒糖"
		HALLOWEENCANDY_11 = "也许会有酒心的？",		-- 物品名:"巧克力猪"
		HALLOWEENCANDY_12 = "江南某些地方会做这种特殊的“美食”，并津津有味。", --ONI meal lice candy		-- 物品名:"糖果虱"
		HALLOWEENCANDY_13 = "我该用它把臭棋篓子砸醒。", --Griftlands themed candy		-- 物品名:"无敌硬糖"
		HALLOWEENCANDY_14 = "辣味糖，只是这次没人再会上当了。", --Hot Lava pepper candy		-- 物品名:"熔岩椒"

		HALLOWEENPOTION_FIRE_FX = "美丽的烟花就是这样做出来的。",		-- 物品名:"石灰硫化晶体和硝化硫酸晶体"

		-- 万圣节饰品	
		HALLOWEEN_ORNAMENT_1 = "有趣的装饰。",		-- 物品名:"幽灵装饰"
		HALLOWEEN_ORNAMENT_2 = "很符合现在的氛围。",		-- 物品名:"蝙蝠装饰"
		HALLOWEEN_ORNAMENT_3 = "我猜今晚年就会把它放到夕身上。",		-- 物品名:"蜘蛛装饰"
		HALLOWEEN_ORNAMENT_4 = "有点像蕨菜？",		-- 物品名:"触手装饰"
		HALLOWEEN_ORNAMENT_5 = "在里面塞一些线，应该是不错的主意。",		-- 物品名:"悬垂蜘蛛装饰"
		HALLOWEEN_ORNAMENT_6 = "外来的节日也会把你当成恐怖的象征啊。",		-- 物品名:"乌鸦装饰"
	-- 冬季盛宴 	-----------------------------------------------------------------------------------------------------------
		-- 圣诞树
		WINTER_TREE =
		{
			BURNT = "诶呦，意外火灾。",		-- 物品名:"冬季圣诞树"->烧焦的
			BURNING = "还能补救一下。",		-- 物品名:"冬季圣诞树"->正在燃烧
			CANDECORATE = "节日快乐！",		-- 物品名:"冬季圣诞树"->已长成，可以装饰
			YOUNG = "节日盆栽正在长大！",		-- 物品名:"冬季圣诞树"->还在成长
		},
		-- 圣诞树盆
		WINTER_TREESTAND =
		{
			GENERIC = "直接挖树不现实，从头开始吧。",		-- 物品名:"圣诞树墩"->默认 制造描述:"种植并装饰一棵冬季圣诞树！"
			BURNT = "诶呦，意外火灾。",		-- 物品名:"圣诞树墩"->烧焦的 制造描述:"种植并装饰一棵冬季圣诞树！"
		},
		-- 冬季盛宴饰品
		WINTER_ORNAMENT = "小巧可爱的饰品。",		-- 物品名:"圣诞小玩意"
		WINTER_ORNAMENTLIGHT = "微火灼破永夜深，孤光虽微亦照心",		-- 物品名:"圣诞灯"
		WINTER_ORNAMENTBOSS = "每一种都富有特色。",		-- 物品名:"华丽的装饰"
		WINTER_ORNAMENTFORGE = "大围猎吗？这次让我们以“人”的身份与你们一同。",		-- 物品名:"熔炉装饰"
		WINTER_ORNAMENTGORGE = "要来一场厨艺比拼吗？",		-- 物品名:"暴食装饰"
		-- 冬季盛宴礼物
		GIFT = "是给我的吗？",		-- 物品名:"礼物"
		GIFTWRAP = "一份心意打包盒。",		-- 物品名:"礼物包装" 制造描述:"把东西打包起来，好看又可爱！"

		-- 圣诞零食
		WINTER_FOOD1 = "看起来味道不错。", --gingerbread cookie		-- 物品名:"小姜饼"
		WINTER_FOOD2 = "雪夜的味道。", --sugar cookie		-- 物品名:"糖曲奇饼"
		WINTER_FOOD3 = "有趣的外观，下次让黍做一些。", --candy cane		-- 物品名:"拐杖糖"
		WINTER_FOOD4 = "谁会吃这个呢？", --fruitcake		-- 物品名:"永远的水果蛋糕"
		WINTER_FOOD5 = "市井小巷里也能买到的美味。", --yule log cake		-- 物品名:"巧克力树洞蛋糕"
		WINTER_FOOD6 = "“投我以桃，报之以李。", --plum pudding		-- 物品名:"李子布丁"
		WINTER_FOOD7 = "虽然没什么酒味，但味道不错。", --apple cider		-- 物品名:"苹果酒"
		WINTER_FOOD8 = "冬夜炉边的饮料。", --hot cocoa		-- 物品名:"热可可"
		WINTER_FOOD9 = "奇特的酒，下次我也尝试下。", --eggnog		-- 物品名:"美味的蛋酒"
		-- 砖砌烤炉
		WINTERSFEASTOVEN =
		{
			GENERIC = "要在火炉上烤点什么吗？",		-- 物品名:"砖砌烤炉"->默认 制造描述:"燃起了喜庆的火焰。"
			COOKING = "心急不得。",		-- 物品名:"砖砌烤炉"->烹饪中 制造描述:"燃起了喜庆的火焰。"
			ALMOST_DONE_COOKING = "莫急，快了。",		-- 物品名:"砖砌烤炉"->即将出炉 制造描述:"燃起了喜庆的火焰。"
			DISH_READY = "新鲜出炉。",		-- 物品名:"砖砌烤炉"->已做好 制造描述:"燃起了喜庆的火焰。"
		},
		-- 冬季盛宴菜肴
		BERRYSAUCE = "美味的果酱。",		-- 物品名:"快乐浆果酱"
		BIBINGKA = "松软的米糕。",		-- 物品名:"比宾卡米糕"
		CABBAGEROLLS = "卖相不错啊。",		-- 物品名:"白菜卷"
		FESTIVEFISH = "鲜美。",		-- 物品名:"节庆鱼料理"
		GRAVY = "浇盖在羊头上更好。",		-- 物品名:"好肉汁"
		LATKES = "特色土豆圈。",		-- 物品名:"土豆饼"
		LUTEFISK = "那有喇叭鱼吗？来自其他地区的特色美食。",		-- 物品名:"苏打鱼"
		MULLEDDRINK = "更多的香味掩盖了酒本身的味道。",		-- 物品名:"香料潘趣酒"
		PANETTONE = "硬邦邦，但是能啃得动。",		-- 物品名:"托尼甜面包"
		PAVLOVA = "《天鹅之死》。",		-- 物品名:"巴甫洛娃蛋糕"
		PICKLEDHERRING = "腌制鱼肉卷。",		-- 物品名:"腌鲱鱼"
		POLISHCOOKIE = "满满的水果。",		-- 物品名:"波兰饼干"
		PUMPKINPIE = "吃掉吃掉，统统吃掉。",		-- 物品名:"南瓜派"
		ROASTTURKEY = "肥美多汁。",		-- 物品名:"烤火鸡"
		STUFFING = "美味无比。",		-- 物品名:"烤火鸡面包馅"
		SWEETPOTATO = "田园风味。",		-- 物品名:"红薯焗饭"
		TAMALES = "热带风味。",		-- 物品名:"塔马利"
		TOURTIERE = "丰盛的肉馅。",		-- 物品名:"饕餮馅饼"
		-- 冬季盛宴餐桌
		TABLE_WINTERS_FEAST =
		{
			GENERIC = "节精致的桌子。",		-- 物品名:"冬季盛宴餐桌"->默认 制造描述:"一起来享用冬季盛宴吧。"
			HAS_FOOD = "满汉全席。",		-- 物品名:"冬季盛宴餐桌"->食物已摆好 制造描述:"一起来享用冬季盛宴吧。"
			WRONG_TYPE = "也许该换种食物？",		-- 物品名:"冬季盛宴餐桌"->食物不对 制造描述:"一起来享用冬季盛宴吧。"
			BURNT = "大火吞噬的节日的欢愉。",		-- 物品名:"冬季盛宴餐桌"->烧焦的 制造描述:"一起来享用冬季盛宴吧。"
		},
		-- 姜饼生物
		GINGERBREADWARG = "可以吃的“头狼”。",		-- 物品名:"姜饼座狼"
		GINGERBREADHOUSE = "贪吃的人可不能住进去。",		-- 物品名:"姜饼猪屋"
		GINGERBREADPIG = "奇怪，食物也有执念？",		-- 物品名:"姜饼猪"
		CRUMBS = "曾是它的一部分。",		-- 物品名:"饼干屑"
		
		WINTERSFEASTFUEL = "充满欢乐与魔力的小雪团。",		-- 物品名:"节日欢愉"
		--  雪人
		SNOWMAN =
		{
			GENERIC = "不错不错。",  --  已经堆好的
			SNOWBALL = "我已经有了大致的想法……", --  正在堆
		},
		--  雪球(物品)
        SNOWBALL_ITEM = "要打雪仗吗？两军对垒那种。",
-- 年限活动 通用------------------------------------------------------------------------------------------------------------
		LUCKY_GOLDNUGGET = "八个弟妹，又是一笔开销。哦，差点忘了我们的十三弟。",		-- 物品名:"幸运黄金"
		REDPOUCH = "又该给弟妹们准备了。",		-- 物品名:"红包"

		REDLANTERN = "想听听关于它和绣花鞋的故事吗？",		-- 物品名:"红灯笼" 制造描述:"照亮你的路的幸运灯笼。"
		MINIBOATLANTERN = "一盏漂流灯。",		-- 物品名:"漂浮灯笼" 制造描述:"闪着暖暖的光亮。"

		FIRECRACKERS = "爆竹声中一岁除， 春风送暖入屠苏。",		-- 物品名:"红鞭炮" 制造描述:"用重击来庆祝！"
		PERDFAN = "把霉运吹走。",		-- 物品名:"幸运扇" 制造描述:"额外的运气，超级多。"

		DRAGONHEADHAT = "我扮演我吗？有趣。",		-- 物品名:"幸运兽脑袋" 制造描述:"野兽装束的前端。"
		DRAGONBODYHAT = "这部分，就交给我可爱弟妹吧。",		-- 物品名:"幸运兽躯体" 制造描述:"野兽装束的中间部分。"
		DRAGONTAILHAT = "让左将军来吧，毕竟也是我的十三弟，不是吗？",		-- 物品名:"幸运兽尾巴" 制造描述:"野兽装束的尾端。"
     -- 火鸡之年活动 -----------------------------------------------------------------------------------------------------
		PERDSHRINE =
		{
			GENERIC = "让那些小馋猫鸡拜谒它们信仰的神。",		-- 物品名:"火鸡神龛"->默认 制造描述:"供奉庄严之火鸡。"
			EMPTY = "得有东西吸引它们，",		-- 物品名:"火鸡神龛" 制造描述:"供奉庄严之火鸡。"
			BURNT = "看来祂没有被赦免。",		-- 物品名:"火鸡神龛"->烧焦的 制造描述:"供奉庄严之火鸡。"
		},
	-- 座狼之年活动 ------------------------------------------------------------------------------------------------------
        -- 座狼神龛
		WARGSHRINE =
		{
			GENERIC = "它想和我们一起玩。",		-- 物品名:"座狼神龛"->默认 制造描述:"供奉陶土之座狼。"
			EMPTY = "它值得被人们供奉一柱。",		-- 物品名:"座狼神龛"->空的 制造描述:"供奉陶土之座狼。"
			BURNING = "燃放爆竹时应该离神龛远点的。", --for willow to override		-- 物品名:"座狼神龛"->正在燃烧 制造描述:"供奉陶土之座狼。"
			BURNT = "看来这场盛宴结束了。",		-- 物品名:"座狼神龛"->烧焦的 制造描述:"供奉陶土之座狼。"
		},
		-- 黏土座狼
		CLAYWARG =
		{
			GENERIC = "看来你对你的创作者很不满意啊。",		-- 物品名:"黏土座狼"->默认
			STATUE = "眼中无神。",		-- 物品名:"黏土座狼"->雕像状态
		},
		-- 黏土猎犬
		CLAYHOUND =
		{
			GENERIC = "你也想逍遥快活一番？",		-- 物品名:"黏土猎犬"->默认
			STATUE = "雕塑家在你身上用了不少心思。",		-- 物品名:"黏土猎犬"->雕像状态
		},

		HOUNDWHISTLE = "人类花了数代人的时间将狼驯化。",		-- 物品名:"幸运哨子" 制造描述:"对野猎犬吹哨。"
	-- 猪王之年活动 ------------------------------------------------------------------------------------------------------
		-- 猪人神龛
		PIGSHRINE =
		{
			GENERIC = "它确实很富有，看那只猪王就知道了。",		-- 物品名:"猪神龛"->默认 制造描述:"供奉富饶之猪人。"
			EMPTY = "我记得猪人喜欢肉类。",		-- 物品名:"猪神龛"->空的 制造描述:"供奉富饶之猪人。"
			BURNT = "烧焦了。",		-- 物品名:"猪神龛"->烧焦的 制造描述:"供奉富饶之猪人。"
		},

		PIG_TOKEN = "似乎是源于怯薛的习俗？",		-- 物品名:"金色腰带"
		PIG_COIN = "一份人情在有需要的时候会有人来帮我。",		-- 物品名:"猪鼻铸币"
		
		YOTP_FOOD1 = "凯旋的盛宴。",		-- 物品名:"致敬烤肉" 制造描述:"向猪王敬肉。"
		YOTP_FOOD2 = "至少口味比芙蓉营养餐要好。",		-- 物品名:"八宝泥馅饼" 制造描述:"那里隐藏着什么？"
		YOTP_FOOD3 = "这几条鱼算是白死了。",		-- 物品名:"鱼头串" 制造描述:"棍子上的荣华富贵。"
		-- 精英猪人/四大猪人护法(抢黄金比赛)
		PIGELITE1 = "猪人的精英。", --BLUE		-- 物品名:"韦德"->抢币游戏的猪人
		PIGELITE2 = "猪人的精英。", --RED		-- 物品名:"伊格内修斯"->抢币游戏的猪人
		PIGELITE3 = "猪人的精英。", --WHITE		-- 物品名:"德米特里"->抢币游戏的猪人
		PIGELITE4 = "猪人的精英。", --GREEN		-- 物品名:"索耶"->抢币游戏的猪人
		-- 精英猪人/四大猪人护法(召唤物)
		PIGELITEFIGHTER1 = "你好，韦德先生。", --BLUE		-- 物品名:"韦德"猪鼻铸币召唤出来的猪人
		PIGELITEFIGHTER2 = "你好，伊格内修斯先生。", --RED		-- 物品名:"伊格内修斯"猪鼻铸币召唤出来的猪人
		PIGELITEFIGHTER3 = "你好，德米特里先生。", --WHITE		-- 物品名:"德米特里"猪鼻铸币召唤出来的猪人
		PIGELITEFIGHTER4 = "你好，索耶先生。", --GREEN		-- 物品名:"索耶"猪鼻铸币召唤出来的猪人
	-- 胡萝卜鼠之年活动 	---------------------------------------------------------------------------------------------------
		-- 胡萝卜鼠神龛
		YOTC_CARRATSHRINE =
		{
			GENERIC = "耗自谓之。",		-- 物品名:"胡萝卜鼠神龛"->默认 制造描述:"供奉灵巧之胡萝卜鼠。"
			EMPTY = "胡萝卜鼠当然喜欢胡萝卜。",		-- 物品名:"胡萝卜鼠神龛"->空的 制造描述:"供奉灵巧之胡萝卜鼠。"
			BURNT = "一股胡萝卜派的味道。",		-- 物品名:"胡萝卜鼠神龛"->烧焦的 制造描述:"供奉灵巧之胡萝卜鼠。"
		},
		CARRAT_GHOSTRACER = "你也是来比赛的吗？暗影的现任“主人”？",		-- 物品名:"查理的胡萝卜鼠"
		-- 起点
		YOTC_CARRAT_RACE_START = "起跑线。",		-- 物品名:"起点" 制造描述:"冲向比赛！"
		YOTC_CARRAT_RACE_START_ITEM = "起跑线。",		-- 物品名:"起点套装" 制造描述:"冲向比赛！"
		-- 检查点
		YOTC_CARRAT_RACE_CHECKPOINT = "必须抵达的目标。",		-- 物品名:"检查点" 制造描述:"通往光荣之路上的一站。"
		YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "必须抵达的目标。",		-- 物品名:"检查点套装" 制造描述:"通往光荣之路上的一站。"
		-- 终点
		YOTC_CARRAT_RACE_FINISH_ITEM = "有始有终。",		-- 物品名:"终点线套装" 制造描述:"你走投无路了。"
		YOTC_CARRAT_RACE_FINISH =
		{
			GENERIC = "有始有终。",		-- 物品名:"终点线"->默认 制造描述:"你走投无路了。"
			BURNT = "看来有人气急败坏了？",		-- 物品名:"终点线"->烧焦的 制造描述:"你走投无路了。"
			I_WON = "艺高人胆大。",		-- 物品名:"终点线"->我赢了 制造描述:"你走投无路了。"
			SOMEONE_ELSE_WON = "志得意满，如被子满盈，{winner}，是属于你的胜利。",		-- 物品名:"终点线"->别人赢了 制造描述:"你走投无路了。"
		},
		-- 奖励
		YOTC_SEEDPACKET = "看看里面会有什么？",		-- 物品名:"种子包" 制造描述:"一包普通的混合种子。"
		YOTC_SEEDPACKET_RARE = "那位神农带回了希望，也带回了灾厄。",		-- 物品名:"高级种子包" 制造描述:"一包高质量的种子。"
		-- 方向健身房
		YOTC_CARRAT_GYM_DIRECTION_ITEM = "方向感很重要。",		-- 物品名:"方向健身房套装" 制造描述:"提高你的胡萝卜鼠的方向感。"
		YOTC_CARRAT_GYM_DIRECTION =
		{
			GENERIC = "方向感很重要。",		-- 物品名:"方向健身房"->默认
			RAT = "加油，你可以的。",		-- 物品名:"方向健身房"->训练中
			BURNT = "看来转速太快了。",		-- 物品名:"方向健身房"->烧焦的
		},
		-- 速度健身房
		YOTC_CARRAT_GYM_SPEED_ITEM = "疾如风。",		-- 物品名:"速度健身房套装" 制造描述:"增加你的胡萝卜鼠的速度。"
		YOTC_CARRAT_GYM_SPEED =
		{
			GENERIC = "疾如风。",		-- 物品名:"速度健身房"->默认
			RAT = "快适应了。",		-- 物品名:"速度健身房"->训练中
			BURNT = "跑得燃起来了。",		-- 物品名:"速度健身房"->烧焦的
		},
		-- 反应健身房
		YOTC_CARRAT_GYM_REACTION_ITEM = "随机应变。",		-- 物品名:"反应健身房套装" 制造描述:"加快你的胡萝卜鼠的反应时间。"
		YOTC_CARRAT_GYM_REACTION =
		{
			GENERIC = "随机应变。",		-- 物品名:"反应健身房"->默认
			RAT = "你永远不知道下一秒会发生什么。",		-- 物品名:"反应健身房"->训练中
			BURNT = "看来这个装置没用了。",		-- 物品名:"反应健身房"->烧焦的
		},
		-- 耐力健身房
		YOTC_CARRAT_GYM_STAMINA_ITEM = "其徐如林。",		-- 物品名:"耐力健身房套装" 制造描述:"增强你的胡萝卜鼠的耐力。"
		YOTC_CARRAT_GYM_STAMINA =
		{
			GENERIC = "其徐如林。",		-- 物品名:"耐力健身房"->默认
			RAT = "挑战自己的极限。",		-- 物品名:"耐力健身房"->训练中
			BURNT = "飞起来了。",		-- 物品名:"耐力健身房"->烧焦的
		},
		-- 胡萝卜鼠称
		YOTC_CARRAT_SCALE_ITEM = "你都有什么能力呢？",		-- 物品名:"胡萝卜鼠秤套装" 制造描述:"看看你的胡萝卜鼠的情况。"
		YOTC_CARRAT_SCALE =
		{
			GENERIC = "也许得加强训练。",		-- 物品名:"胡萝卜鼠秤"->默认
			CARRAT = "它需要锻炼。",		-- 物品名:"胡萝卜鼠秤"->胡萝卜鼠属性较差 制造描述:"灵巧机敏，富含胡萝卜素。"
			CARRAT_GOOD = "足够强大了。",		-- 物品名:"胡萝卜鼠秤"->胡萝卜鼠属性较好
			BURNT = "真是一团糟。",		-- 物品名:"胡萝卜鼠秤"->烧焦的
		},
	-- 皮弗娄牛之年活动 	---------------------------------------------------------------------------------------------------
        -- 皮弗娄牛神龛
		YOTB_BEEFALOSHRINE =
		{
			GENERIC = "想要来一场装扮比赛吗？",		-- 物品名:"皮弗娄牛神龛"->默认 制造描述:"供奉坚毅的皮弗娄牛。"
			EMPTY = "也许该放点牛毛。",		-- 物品名:"皮弗娄牛神龛"->空的 制造描述:"供奉坚毅的皮弗娄牛。"
			BURNT = "闻起来是皮革的味道。",		-- 物品名:"皮弗娄牛神龛"->烧焦的 制造描述:"供奉坚毅的皮弗娄牛。"
		},
		-- 皮弗娄牛美妆台
		BEEFALO_GROOMER =
		{
			GENERIC = "为丰蹄打扮梳妆。",		-- 物品名:"皮弗娄牛美妆台"->默认 制造描述:"美牛原型机。"
			OCCUPIED = "主角已经就位，让我们开始吧！",		-- 物品名:"皮弗娄牛美妆台"->被占领 制造描述:"美牛原型机。"
			BURNT = "看起来火辣辣的。",		-- 物品名:"皮弗娄牛美妆台"->烧焦的 制造描述:"美牛原型机。"
		},
		BEEFALO_GROOMER_ITEM = "该打扮一下了。",		-- 物品名:"美妆台套装" 制造描述:"美牛原型机。"
		-- 皮弗娄牛礼服
		WAR_BLUEPRINT = "披挂百战胄，犄角挑幽冥。",		-- 物品名:"战士礼服款式"
		DOLL_BLUEPRINT = "锦帛系铃铛，缎带簪春花。",		-- 物品名:"娃娃礼服款式"
		FESTIVE_BLUEPRINT = "红绸覆金鞍，铜铃奏丰年。",		-- 物品名:"节日盛装款式"
		ROBOT_BLUEPRINT = "锈铠铸磨盘，戾瞳映血月。",		-- 物品名:"铁甲礼服款式"
		NATURE_BLUEPRINT = "梨辕簪牡丹，缰绳系春风。",		-- 物品名:"花朵礼服款式"
		FORMAL_BLUEPRINT = "颔首承千斤，礼成动四方。",		-- 物品名:"正式礼服款式"
		VICTORIAN_BLUEPRINT = "优雅踱步时，铜铃荡余晖。",		-- 物品名:"维多利亚礼服款式"
		ICE_BLUEPRINT = "冰花缀苍皮，呼气凝霜华。",		-- 物品名:"寒霜礼服款式"
		BEAST_BLUEPRINT = "独角缠赤绫，目嵌辟邪珠。",		-- 物品名:"幸运野兽礼服款式"

		BEEF_BELL = "丰蹄朋友喜欢这个铃铛的声音。",		-- 物品名:"皮弗娄牛铃" 制造描述:"与皮弗娄牛交朋友。"
		-- 缝纫机
		YOTB_SEWINGMACHINE = "为丰蹄朋友准备一件礼服。",		-- 物品名:"缝纫机"
		YOTB_SEWINGMACHINE_ITEM = "看来需要组装一下。",		-- 物品名:"缝纫机套装" 制造描述:"做出完美的皮弗娄牛礼服吧。"
		-- 裁判席
		YOTB_STAGE = "准备开始吧。",		-- 物品名:"裁判席"
		YOTB_STAGE_ITEM = "为裁判提供席位。",		-- 物品名:"裁判席" 制造描述:"邀请专家出席。"
		-- 皮弗娄牛舞台
		YOTB_POST =  "这场比赛将会顺利进行！",		-- 物品名:"皮弗娄牛舞台"
		YOTB_POST_ITEM =  "这是核心舞台。",		-- 物品名:"皮弗娄牛舞台" 制造描述:"让你的皮弗娄牛登上舞台中央。"
		-- 礼服灵感碎片
		YOTB_PATTERN_FRAGMENT_1 = "幽墟裁魇缎，残妆缚夜魄。",		-- 物品名:"恐怖款式碎片" 制造描述:"来一点恐怖的灵感。"
		YOTB_PATTERN_FRAGMENT_2 = "经纬承礼序，针黹纳春秋。",		-- 物品名:"正式款式碎片" 制造描述:"来一点正式的灵感。"
		YOTB_PATTERN_FRAGMENT_3 = "金绣绽千禧，赤绡融烛彤。",		-- 物品名:"喜庆款式碎片" 制造描述:"来一点喜庆的灵感。"
		-- 牛玩偶
		-- 战士皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_WAR = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"战士皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"战士皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 娃娃皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_DOLL = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"娃娃皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"娃娃皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 喜庆皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_FESTIVE = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"喜庆皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"喜庆皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 花朵皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_NATURE = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"花朵皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"花朵皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 铁甲皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_ROBOT = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"铁甲皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"铁甲皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 寒霜皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_ICE = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"寒霜皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"寒霜皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 正式皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_FORMAL = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"正式皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"正式皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 维多利亚皮弗娄牛玩偶
		YOTB_BEEFALO_DOLL_VICTORIAN = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"维多利亚皮弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"维多利亚皮弗娄牛玩偶"->牛年活动进行中
		},
		-- 幸运兽弗娄牛玩偶
		YOTB_BEEFALO_DOLL_BEAST = {
			GENERIC = "漂亮的小玩偶。",		-- 物品名:"幸运野兽弗娄牛玩偶"->默认
			YOTB = "我们的评委怎么看呢？",		-- 物品名:"幸运野兽弗娄牛玩偶"
		},
	-- 浣猫年活动 	--------------------------------------------------------------------------------------------------------
		-- 浣猫年神龛
		YOT_CATCOONSHRINE =
		{
			GENERIC = "可爱的猫猫神。",	-- 物品名:"浣猫神龛"->默认
			EMPTY = "他想要玩弄羽毛。",	-- 物品名:"浣猫神龛"->无物品
			BURNT = "烧焦了。",	-- 物品名:"浣猫神龛"->烧焦
		},
		-- 小浣猫托儿所
		KITCOONDEN_KIT = "为小浣猫精心准备的。",		-- 物品名:"小浣猫托儿所套装"
		KITCOONDEN = 
		{
			GENERIC = "照顾可爱的小浣猫。",		-- 物品名:"小浣猫托儿所"->默认
			BURNT = "我应该做好防火准备的。",		-- 物品名:"小浣猫托儿所"->烧焦
			PLAYING_HIDEANDSEEK = "它们去了哪里呢……",		-- 物品名:"小浣猫托儿所"->捉迷藏进行中
			PLAYING_HIDEANDSEEK_TIME_ALMOST_UP = "它躲到哪里去了？",		-- 物品名:"小浣猫托儿所"->捉迷藏即将结束
		},
		-- 大虎
		TICOON = 
		{
			GENERIC = "它似乎追踪到了其他小猫。",	-- 物品名:"大虎"->默认
			ABANDONED = "我自己就能找到它们。",		-- 物品名:"大虎"->遗弃
			SUCCESS = "我的朋友找到了一只。",		-- 物品名:"大虎"->已找到小浣猫
			LOST_TRACK = "来迟了一步。",		-- 物品名:"大虎"->有人已经找到
			NEARBY = "看起来附近有东西。",	-- 物品名:"大虎"->发现附近小浣猫
			TRACKING = "我应该紧跟他的步伐。",		-- 物品名:"大虎"->追踪小浣猫
			TRACKING_NOT_MINE = "他在为别人引路。",	-- 物品名:"大虎"->帮别人追踪小浣猫
			NOTHING_TO_TRACK = "也许该换个地方。",	-- 物品名:"大虎"->该区域内没有小浣猫
			TARGET_TOO_FAR_AWAY = "似乎离得很远。",	-- 物品名:"大虎"->小浣猫距离太远
		},
			
		KITCOON_NAMETAG = "为小浣猫命名。",	-- 物品名:"小浣猫项圈"
		-- 小浣猫
		KITCOON_FOREST = "可爱的丛林猫咪。",		-- 物品名:"小浣猫"->丛林
		KITCOON_SAVANNA = "可爱的绿地猫咪。",	-- 物品名:"小浣猫"->绿地
		KITCOON_MARSH = "可爱的沼泽猫咪。",			-- 物品名:"小浣猫"->沼泽
		KITCOON_DECIDUOUS = "可爱的桦林猫咪。",	-- 物品名:"小浣猫"->桦树林
		KITCOON_GRASS = "可爱的草原猫咪。",		-- 物品名:"小浣猫"->草原
		KITCOON_ROCKY = "可爱的矿区猫咪。",			-- 物品名:"小浣猫"->矿场
		KITCOON_DESERT = "可爱的沙漠猫咪。",		-- 物品名:"小浣猫"->沙漠
		KITCOON_MOON = "可爱的月亮猫咪。",		-- 物品名:"小浣猫"->月岛
		KITCOON_YOT = "可爱的铃铛猫咪。",		-- 物品名:"小浣猫"->铃铛
		-- 小浣猫玩具
		CATTOY_MOUSE = "为小浣猫找点事做。",	-- 物品名:"发条鼠玩具"
		-- 火鸡不倒翁
		KITCOONDECOR1_KIT = "看起来需要组装一下。",	-- 物品名:"火鸡不倒翁套装"
		KITCOONDECOR1 =
		{
			GENERIC = "不倒翁小玩具",	-- 物品名:"火鸡不倒翁"->默认
			BURNT = "燃起来了。",	-- 物品名:"火鸡不倒翁"->烧焦
		},
		-- 逗猫小鱼
		KITCOONDECOR2_KIT = "该放在哪里呢？",	-- 物品名:"逗猫小鱼套装"
		KITCOONDECOR2 =
		{
			GENERIC = "为猫咪准备的小鱼干。",	-- 物品名:"逗猫小鱼"->默认
			BURNT = "它给烧了。",	-- 物品名:"逗猫小鱼"->烧焦
		},
     -- 兔人年活动 ---------------------------------------------------------------------------------------------------------
		-- 兔人神龛
		YOTR_RABBITSHRINE =
		{
			GENERIC = "看来它很喜欢。",	-- 物品名:"兔人神龛"->默认 制造描述:"供奉舒适之兔人。"
			EMPTY = "卡特斯最喜欢胡萝卜了。",	-- 物品名:"兔人神龛"->空的 制造描述:"供奉舒适之兔人。"
			BURNT = "兔兔这么可爱，可惜变红烧了。",	-- 物品名:"兔人神龛"->烧焦的 制造描述:"供奉舒适之兔人。"
		},

		COZY_BUNNYMAN = "要来一起玩玩吗？",	-- 物品名:"舒适的兔人"
		HAREBALL = "不了…谢谢…",	-- 物品名:"兔毛球"
		YOTR_TOKEN = "要来玩枕头大战吗？",	-- 物品名:"挑战手套" 制造描述:"告诉兔人你想在枕头大战里试试手。"
		NIGHTCAPHAT = "在喝醉前我没什么机会戴上它。",	-- 物品名:"睡帽" 制造描述:"为你打瞌睡的脑袋准备的帽子。"

		YOTR_FIGHTRING_KIT = "来一场激烈的枕头大战吧。",	-- 物品名:"枕头大战坑套装" 制造描述:"究竟谁能成为屹立不倒的枕头战士呢？"		
		-- 枕头大战钟
		YOTR_FIGHTRING_BELL =
		{
			GENERIC = "游戏结束。",	-- 物品名:"枕头大战钟"->默认
			PLAYING = "狂欢开始。",	-- 物品名:"枕头大战钟"->游玩中
		},
		-- 兔年食物
		YOTR_FOOD1 = "胡萝卜蛋糕，切片是可爱的卡特斯。",	-- 物品名:"兔子卷" 制造描述:"制造这个蛋糕的过程中没有兔子受到伤害。"
		YOTR_FOOD2 = "蓝色是最科学的风味。",	-- 物品名:"月饼" 制造描述:"“蓝色”风味！"
		YOTR_FOOD3 = "小饼如嚼月，中有酥与饴。",	-- 物品名:"月冻" 制造描述:"这甜点美的让人不忍心咬一口。"
		YOTR_FOOD4 = "这糖色不错。",	-- 物品名:"泡芙串" 制造描述:"蓬松有嚼劲的球。"
		-- 枕头
		HANDPILLOW_BEEFALOWOOL = "牛毛做成的枕头，软硬适中。",	-- 物品名:"皮弗娄牛毛枕头" 制造描述:"打出一记带牛毛的重击。"
		HANDPILLOW_KELP = "诶呀，湿哒哒的。",	-- 物品名:"海带枕头" 制造描述:"没有人喜欢盖着湿毯子睡。别以为湿枕头能好到哪去。"
		HANDPILLOW_PETALS = "带着花香的一击。",	-- 物品名:"花朵枕头" 制造描述:"枕头里装满了花的力量。"
		HANDPILLOW_STEELWOOL = "睡在上面肯定不舒服。",	-- 物品名:"钢丝绵枕头" 制造描述:"专为枕头大战的严肃参赛者准备。"
		-- 盔甲
		BODYPILLOW_BEEFALOWOOL = "很重的腥味。",	-- 物品名:"皮弗娄牛枕头盔甲" 制造描述:"加强你的枕头防卫。"
		BODYPILLOW_KELP = "能帮某些人降降火。",	-- 物品名:"海带枕头盔甲" 制造描述:"一套湿漉漉的枕头盔甲。"
		BODYPILLOW_PETALS = "伴着花香入眠。",	-- 物品名:"花朵枕头盔甲" 制造描述:"它提供了最低限度的保护，脱下它后你身上会有玫瑰花的香味。"
		BODYPILLOW_STEELWOOL = "小心划伤。",	-- 物品名:"钢丝绵枕头盔甲" 制造描述:"一个可穿戴的枕头，既有效又令人不快。"
		-- 矮兔灯
		YOTR_DECOR_1_ITEM = "该放到哪里呢？",	-- 物品名:"矮兔灯" 制造描述:"这盏可爱的灯能使任何洞穴变得舒适起来。"
		YOTR_DECOR_1 = {
			GENERAL = "心胸宽广的兔子灯。",	-- 物品名:"矮兔灯"->默认
			OUT = "没有燃料了。",	-- 物品名:"矮兔灯"->熄灭
		},
		-- 高兔灯
		YOTR_DECOR_2_ITEM = "该放到哪里呢？",	-- 物品名:"高兔灯" 制造描述:"一尊肚子里真正有火的兔子雕像！"
		YOTR_DECOR_2 = {
			GENERAL = "拥抱众生的兔子灯。",	-- 物品名:"高兔灯"->默认
			OUT = "没有燃料了。",	-- 物品名:"高兔灯"->熄灭
		},


    -- 龙蝇年活动-----------------------------------------------------------------------------------------------
		-- 龙蝇年神龛
		YOTD_DRAGONSHRINE =
		{
			GENERIC = "奇心在燃烧。",	--物品名:"龙蝇神龛"->默认 制造描述:"供奉红火的龙蝇。"
			EMPTY = "它也许想要木炭。",	--物品名:"龙蝇神龛"->空的 制造描述:"供奉红火的龙蝇。"
			BURNT = "看起来它开心坏了。",	--物品名:"龙蝇神龛"->烧焦 制造描述:"供奉红火的龙蝇。"
		},

		BOATRACE_PRIMEMATE = "看来暗影女王也对比赛有兴趣。",	--物品名:"查理的选手"
		BOATRACE_SPECTATOR_DRAGONLING = "龙舟比赛的小观众。",	--物品名:"小龙蝇观赛者"
		-- 起点
		BOATRACE_START = "总得有个起点。",	--物品名:"起点塔"
		BOATRACE_START_THROWABLE_DEPLOYKIT = "起点放在哪呢？",	--物品名:"起点塔套装" 制造描述:"各就位、预备、开划！"
		-- 检查点
		BOATRACE_CHECKPOINT = "比赛的过程比比赛的输赢更重要。",	--物品名:"比赛检查点"
		BOATRACE_CHECKPOINT_THROWABLE_DEPLOYKIT = "这是必要的。",	--物品名:"比赛检查点套装" 制造描述:"重要的是旅程本身而不是终点。"
		-- 龙蝇船
		DRAGONBOAT_BODY = "以龙之名。",-- 龙蝇船
		WALKINGPLANK_YOTD = "想要跳水吗？",	--物品名:"龙鳞跳板"
		DRAGONBOAT_KIT = "潜龙入渊。",	--物品名:"龙蝇船套装" 制造描述:"启动海龙。"
		DRAGONBOAT_PACK = "更豪华的船。",	--物品名:"豪华龙蝇船套装" 制造描述:"配备了所有的龙之配件。"
		
		YOTD_OAR = "好方便的船桨。",	--物品名:"利爪船桨" 制造描述:"关于龙蝇的一个鲜为人知的事实：它们是出人意料的游泳健将。"
		-- 巨爪船锚
		YOTD_ANCHOR = "稳固立足。",	--物品名:"巨爪船锚"
		YOTD_ANCHOR_ITEM = "建造停泊的锚。",	--物品名:"巨爪船锚套装" 制造描述:"船锚的黄金标准。"
		-- 龙蝇船方向舵
		YOTD_STEERINGWHEEL = "驶向正确的航向。",	--物品名:"龙蝇船方向舵"
		YOTD_STEERINGWHEEL_ITEM = "一个方向舵。",	--物品名:"龙蝇船方向舵套装" 制造描述:"掌舵，驶向黄金！"
		-- 龙翼桅杆
		MAST_YOTD = "满是鳞片的帆。",	--物品名:"龙翼桅杆"
		MAST_YOTD_ITEM = "现在我能造出桅杆了。",	--物品名:"龙翼桅杆套装" 制造描述:"制造这个桅杆时没有龙蝇受到伤害。"
		-- 龙蝇灯
		MASTUPGRADE_LAMP_YOTD = "令人眼前一亮。",	--物品名:"龙蝇灯"
		MASTUPGRADE_LAMP_ITEM_YOTD = "让人眼前一亮。",	--物品名:"龙蝇灯套装" 制造描述:"用龙火照亮你的前路。"
		-- 獠牙保险杠
		BOAT_BUMPER_YOTD = "尝尝龙角的滋味。",	--物品名:"獠牙保险杠"
		BOAT_BUMPER_YOTD_KIT = "满是獠牙的保险杠。",	--物品名:"獠牙保险杠套装" 制造描述:"没有人敢招惹呲牙咧嘴的龙。"
		-- 浮标(投掷出去阻挡船的障碍物)
		-- 玩家使用的黄金浮标
		BOATRACE_SEASTACK = "黄金的浮标，固若金汤。",	--物品名:"黄金浮标"
		BOATRACE_SEASTACK_THROWABLE_DEPLOYKIT = "黄金做的浮标。",	--物品名:"黄金浮标套装" 制造描述:"甲之浮标，乙之浮障。"
        -- 暗影大副扔的荆棘浮标
		BOATRACE_SEASTACK_MONKEY = "带刺的浮标，注意躲避。",	--物品名:"荆棘浮标"
		BOATRACE_SEASTACK_MONKEY_THROWABLE_DEPLOYKIT = "满是荆棘的浮标。",	--物品名:"荆棘浮标套装"

	-- 蠕虫蛇年 -----------------------------------------------------------------------------------------------------
        -- 蠕虫神龛
		YOTS_SNAKESHRINE =
        {
            GENERIC = "贪心不足，我第一时间想到了这句。",      --  正常
            EMPTY = "它向我祈求一块怪物肉。", --  空的
            BURNT = "正在熊熊燃烧。",        --  燃烧
        },
		--  镀金蠕虫
        YOTS_WORM = "顺眼多了。",
		--  喜庆灯笼柱
        YOTS_LANTERN_POST =
        {
            GENERIC = "很有节日氛围。", -- 正常
            BURNT = "真是“红红又火火”啊。",              --  燃烧
        },
		--  喜庆灯笼柱套装(物品栏)
        YOTS_LANTERN_POST_ITEM = "长蛇起！",
	-- 发条骑士之年 -----------------------------------------------------------------------------------------------------
		-- 骑士神龛
		YOTH_KNIGHTSHRINE =
		{
			GENERIC = "“骑士精神”。", -- 有供品
			EMPTY = "它在向我祈求齿轮。", -- 无供品
			BURNT = "战士死于战火。", -- 烧毁
		},
		MASK_PRINCESSHAT        = "说起来，我记忆中有几位公主可做出过一番大事业。",            -- 公主帽
		COSTUME_PRINCESS_BODY   = "繁琐的礼仪。", -- 公主服装
		PLAYBILL_THE_PRINCESS_YOTH = "有趣的故事。", -- 《我的四骑士与我》剧本
		-- 骑士
		KNIGHT_YOTH =
		{
			GENERIC = "杀死大海！杀死大海！", -- 普通(敌对)
			FOLLOWING = "荣耀，必须被捍卫。", -- 跟随
			FOLLOWING_OTHER = "愿光芒浸润你。", -- 跟随他人
		},
		YOTH_KNIGHTHAT = "戴冠，备马。", -- 骑士帽
		ARMOR_YOTH_KNIGHT = "披甲，出征。", -- 骑士盔甲
		HORSESHOE = "也许真的用用，谁知道呢。", -- 马蹄铁
		YOTH_LANCE = "横枪立马，一骑当千。", -- 骑士长枪
		-- 浮动灯笼
		FLOATINGLANTERN =
		{
			DEFLATED = "喜庆的气氛总是如此短暂。", -- 放气
			HELD     = "它终将升入群星。", -- 持有
			GENERIC  = "似是空中楼阁。", -- 漂浮
		},

		YOTH_KNIGHTSTICK = "一骑绝尘。", -- 骑士手杖
		YOTH_CHAIR_ROCKING_ITEM = "罢了，躺会也好。", -- 摇椅物品
---------联动内容 ------------------------------------------------------------------------------------------------------
        -- 小丑牌
		DECK_OF_CARDS 	= "无趣的玩戏。", --  纸牌堆
        PLAYING_CARD 	= "要我猜这张是什么吗？", --  单张纸牌
        BALATRO_MACHINE = "玩物丧志。", --  小丑牌机器
---------暂时未知与留待未来更新区域 --------------------------------------------------------------------------------------
		DEVTOOL = "It smells of bacon!",-- 未知
		DEVTOOL_NODEV = "I'm not strong enough to wield it.",-- 未知
---------单机版遗留 ------------------------------------------------------------------------------------------------------
		ACCOMPLISHMENT_SHRINE = "没必要的证明。",	-- 物品名:"奖杯"（单机） 制造描述:"证明你作为一个人的价值。"
		BELL_BLUEPRINT = "巨大的钟。",-- 钟蓝图，单机版巨人国内容
		BELL = "叮呤呤。",		-- 物品名:"远古铃铛"（单机） 制造描述:"这可不是普通的铃铛。"
		BIGFOOT = "巨大无比的脚。",-- 物品名:"大脚怪"->大脚怪（单机）
		CAVE_ENTRANCE_RUINS = "它有可能在隐瞒什么事情。",		-- 物品名:"被堵住的陷洞"（单机洞二入口）
        -- 单机版遗留，农田
		FARMPLOT =
		{
			GENERIC = "我应该试着种一些庄稼。",		-- 物品名:"农场"（旧版）
			GROWING = "生长吧。",		-- 物品名:"农场"（旧版）
			NEEDSFERTILIZER = "需要施些肥料。",		-- 物品名:"农场"（旧版）
			BURNT = "灰烬中长不出庄稼。",		-- 物品名:"农场"（旧版）
		},
		WEBBERSKULL = "死者应安息。",		-- 物品名:"韦伯的头骨"
		MALE_PUPPET = "他被困住了。", 	-- 物品名:未知（单机）
		-- 熔岩坑，疑似单机版海难遗留
		ROCK_LIGHT =
		{
			GENERIC = "裹了石皮的熔岩坑。",-- 物品名:"熔岩坑"->默认
			OUT = "看起来很易碎。",-- 物品名:"熔岩坑"->出去？外面？
			LOW = "那块熔岩正在裹上石皮。",-- 物品名:"熔岩坑"->低？
			NORMAL = "真舒服。",-- 物品名:"熔岩坑"->普通
		},
		BASALT = "太硬了，敲不碎！", -- 物品名:"玄武岩"（彩蛋物体）
		FEM_PUPPET = "她被困住了！", -- 物品名:未找到（单机）
		-- 冒险模式相关
		ADVENTURE_PORTAL = "我不想再一次上当了。",		-- 物品名:"麦斯威尔之门"->（单机）
		TRAP_TEETH_MAXWELL = "谁会这么恶趣味。",-- 物品名:"麦斯威尔的犬牙陷阱"（单机） 制造描述:"弹出来并咬伤任何踩到它的东西。"
		-- 单机版遗留，木质传送台
		TELEPORTATO_BASE =
		{
			ACTIVE = "梦遍大千世界。", -- 物品名:"木制传送台"（单机）->激活了
			GENERIC = "异世界传送门。", -- 物品名:"木制传送台"（单机）->默认
			LOCKED = "缺少很多关键的东西。",-- 物品名:"木制传送台"（单机）->锁住了
			PARTIAL = "似乎还差一些部分？",-- 物品名:"木制传送台"（单机）->已经有部分了
		},
		TELEPORTATO_BOX = "一个调节器。",-- 物品名:"盒状零件"（单机）
		TELEPORTATO_CRANK = "一个曲柄。", -- 物品名:"曲柄零件"（单机）
		TELEPORTATO_POTATO = "为什么叫它土豆？",-- 物品名:"金属土豆状零件"（单机）
		TELEPORTATO_RING = "不知道有什么作用的零件。", -- 物品名:"环状零件"（单机）
		
		MAXWELL = "不讨喜的家伙。",-- 物品名:"麦斯威尔"->（单机）
		MAXWELLPHONOGRAPH = "会是谁的留声机。",-- 物品名:"麦斯威尔的留声机"->（单机冒险模式）
		MAXWELLHEAD = "欸，你怎么似了。",-- 物品名:"麦斯威尔的头"->（单机）
		MAXWELLLIGHT = "“声”控灯。",-- 物品名:"麦斯威尔灯"->（单机）
		MAXWELLLOCK = "很明显这是个陷阱。",-- 物品名:"梦魇锁"->（单机）
		MAXWELLTHRONE = "王座从来都不会让人舒服。",-- 物品名:"梦魇王座"->（单机）
		ANNOUNCE_FREEDOM = "结束了。",		--未应用（废案）
		DEADLYFEAST = "死亡的盛宴。", --unimplemented		-- 物品名:"致命的盛宴"->（单机）
		-- 占卜杖/探测仪台词，单机版遗留内容
		DIVININGROD =
		{
			COLD = "信号很弱。", -- 物品名:"探测杖"（单机）->冷了
			GENERIC = "某种自动引导装置。",-- 物品名:"探测杖"（单机）->默认 制造描述:"肯定有方法可以离开这里..."
			HOT = "这东西很疯狂。",-- 物品名:"探测杖"（单机）->热了
			WARM = "这个方向是对的。", -- 物品名:"探测杖"（单机）->温暖 制造描述:"肯定有方法可以离开这里..."
			WARMER = "快接近那里了。", -- 物品名:"探测杖"（单机） 制造描述:"肯定有方法可以离开这里..."
		},
		-- 探测杖基座，单机版遗留内容
		DIVININGRODBASE =
		{
			GENERIC = "道它有什么用呢？", -- 物品名:"探测杖底座"（单机）->默认
			READY = "看起来它需要一把大钥匙。", -- 物品名:"探测杖底座"（单机）->准备好的 满的
			UNLOCKED = "现在机器可以工作了。", -- 物品名:"探测杖底座"（单机）->解锁了
		},
		DIVININGRODSTART = "那根手杖看起来有用。！", -- 物品名:"探测杖底座"（单机）
	--废案 ------------------------------------------------------------------------------------------------------------
		-- 疑似废案友谊传送门
		 MIGRATION_PORTAL = 
		 {
            GENERIC = "If I had any friends, this could take me to them.",
            OPEN = "If I step through, will I still be me?",
            FULL = "It seems to be popular over there.",
        },
		ANNOUNCE_NO_TRAP = "好吧，挺简单的。",		--没有陷阱（未应用）
		ANNOUNCE_LOWRESEARCH = "我没从那儿学到什么。",		--未应用（废案）
		ANNOUNCE_ACCOMPLISHMENT = "我觉得好有成就感！",		--（未应用）
		ANNOUNCE_ACCOMPLISHMENT_DONE = "如果我的朋友现在能看到我就好了...",		--（未应用）
		ANNOUNCE_RESEARCH = "活到老学到老！",		--（未应用）
		ANNOUNCE_UNIMPLEMENTED = "噢！这应该还没准备好。",		--（未应用）
		
		FISHINGNET = "就是一张网。", -- 物品名:"渔网"（未应用） 制造描述:"就是一张网。"
		ANTCHOVIES = "啊,我能丢回去吗？", -- 物品名:"蚁头凤尾鱼"（未应用）
        -- 人肉，废案
		HUMANMEAT = "。。。。。。",		-- 物品名:"长猪"
		HUMANMEAT_COOKED = "。。。。。。",		-- 物品名:"煮熟的长猪"
		HUMANMEAT_DRIED = "。。。。。。",		-- 物品名:"长猪肉干"
		
		HOME = "这里有人生活的痕迹。",		-- 物品名:未知（未应用）
		SKULLCHEST = "天晓得那里面藏着什么东西！", -- 单机版遗留废案，骷髅箱
		ANNOUNCE_HIGHRESEARCH = "感觉我现在太聪明了！",		--未应用（废案）
				
		COLLAPSEDCHEST = "被砸毁了。",	-- 物品名:"毁掉的箱子"（未应用）		
		UNIMPLEMENTED = "半成品总会有风险。",		-- 物品名:"懒人护符"->未完工（已移除）
		-- 迷你冰山
		ICEBERG =
		{
			GENERIC = "海上的冰山。", --unimplemented		-- 物品名:"迷你冰山"（未应用）->默认
			MELTED = "融化了。", --unimplemented		-- 物品名:"迷你冰山"（未应用）->融化了
		},
		ICEBERG_MELTED = "融化了。", --unimplemented		-- 物品名:"融化的迷你冰山"（未应用）
		-- 木桌（不知用途）
		WOOD_TABLE = -- Shared between the round and square tables.
		{
			GENERIC = "无物扰心绪，有空待风聆。",	-- 物品名:"木圆桌/木方桌"->无东西 制造描述:"一张置物的木圆桌。/一张置物的木方桌。"
			HAS_ITEM = "陈杂承百物，纳尽世间忙。",	-- 物品名:"木圆桌/木方桌"->有东西 制造描述:"一张置物的木圆桌。/一张置物的木方桌。"
			BURNT = "残骸委地烬，形骸化焦尘。",	-- 物品名:"木圆桌/木方桌"->烧毁 制造描述:"一张置物的木圆桌。/一张置物的木方桌。"
		},
	},	
}
