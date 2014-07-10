	cmd = {}

	--存储已经汇报过的错误
	cmd.errors = {}

	--重载print
	cmd.print = print

	cmd.text_print = {}
	
	function print(...)
		table.insert(cmd.text_print, table.concat({...}, '\t'))
	end

	--调用栈
	function runtime.error_handle(msg)
		if cmd.errors[msg] then
			return
		end
		if not runtime.console then
			cmd.errors[1] = 1
			jass.DisplayTimedTextToPlayer(jass.GetLocalPlayer(), 0, 0, 60, msg)
		end
		cmd.errors[msg] = true
		print(cmd.getMaidName() .. ":Lua引擎汇报了一个错误,主人快截图汇报!")
		print("---------------------------------------")
		print(tostring(msg) .. "\n")
		print(debug.traceback())
		print("---------------------------------------")
	end

	--cmd指令接口
	function cmd.start()
		cmd[jass.GetPlayerName(jass.Player(12)):sub(2)](player.j_player(jass.Lua_player))
	end

	--初始化
	function cmd.main()
		cmd.maid_name()
		cmd.hello_world()
		cmd.check_error()
		cmd.check_handles()
	end

	--获取女仆名字
	cmd.maidNames = {
		{'能干的白丝萝莉女仆'},
		{'能干的黑丝萝莉女仆'},
	}

	cmd.maidNames[1][2] = '鑳藉共鐨勭櫧涓濊悵鑾夊コ浠�'
	cmd.maidNames[2][2] = '鑳藉共鐨勯粦涓濊悵鑾夊コ浠�'
		
	function cmd.maid_name()
		for i = 0, 11 do
			local name = cmd.maidNames[jass.GetRandomInt(1, #cmd.maidNames)]
			if jass.Player(i) == jass.GetLocalPlayer() then
				cmd.maidNames[0] = name
			end
		end
	end

	function cmd.getMaidName(utf8)
		return cmd.maidNames[0][utf8 and 2 or 1]
	end

	function cmd.check_error()
		timer.loop(60,
	        function()
	            if cmd.errors[1] then
		            
					jass.SetPlayerName(jass.Player(12), '|cffff88cc' .. cmd.getMaidName(true) .. '|r')
	                japi.EXDisplayChat(jass.Player(12), 3, '|cffff88cc鍒氭墠lua鑴氭湰姹囨姤浜嗕竴涓敊璇�,甯繖鎴浘姹囨姤涓�涓嬮敊璇彲浠ュ槢?|r')
	                japi.EXDisplayChat(jass.Player(12), 3, '|cffff88cc瀵逛簡,涓讳汉鍙互杈撳叆",cmd"鏉ユ墦寮�cmd绐楀彛鏌ョ湅閿欒鍝�,璋㈣阿涓讳汉鍠祙r')
	                
	                cmd.errors[1] = cmd.errors[1] + 1
	                if cmd.errors[1] > 3 then
		                cmd.errors[1] = false
	                end
	            end
	        end
	    )
    end

    function cmd.cmd(p)
	    local open
	    if p == player.self then
            if runtime.console then
	            jass.SetPlayerName(jass.Player(12), '|cffff88cc' .. cmd.getMaidName(true) .. '|r')
	            japi.EXDisplayChat(jass.Player(12), 3, '|cffff88cc宸茬粡甯富浜哄叧鎺変簡鍠祙r')
	            runtime.console = false
            else
	            open = true
				jass.SetPlayerName(jass.Player(12), '|cffff88cc' .. cmd.getMaidName(true) .. '|r')
	            japi.EXDisplayChat(jass.Player(12), 3, '|cffff88cccmd绐楀彛灏嗗湪3绉掑悗鎵撳紑,濡傛灉涓讳汉鎯冲叧鎺夌殑璇濆彧瑕亅r')
	            japi.EXDisplayChat(jass.Player(12), 3, '|cffff88cc鍐嶆杈撳叆",cmd"灏卞彲浠ヤ簡,鍗冧竾涓嶈鐩存帴鍘诲叧鎺夌獥鍙ｅ摝|r')
            end
            
	    end
	    timer.wait(3,
	    	function()
		    	if open then
			    	runtime.console = true
			    	if print ~= cmd.print then
				    	--说明是第一次开启
				    	print = cmd.print
				    	for i = 1, #cmd.text_print do
					    	print(cmd.text_print[i])
				    	end
			    	end
				end
			end
	    )
	end

	--初始文本
	function cmd.hello_world()
		print(cmd.getMaidName() .. ':主人您好,我是您的私人专属女仆,我会在后台默默的收集一些性能数据,如果主人在游戏结束的时候可以截图展示一下我会很开心的!\n')
	end

	--检测句柄
	cmd.handle_data = {}
	
	function cmd.check_handles()
		timer.wait(5,
			function()
				local handles = {}
				for i = 1, 10 do
					handles[i] = jass.Location(0, 0)
				end
				cmd.handle_data[0] = math.max(unpack(handles)) - 1000000
				for i = 1, 10 do
					jass.RemoveLocation(handles[i])
				end

				print(('%s:主人,我测试了一下游戏开始的时候游戏中有[%d]个数据哦'):format(cmd.getMaidName(), cmd.handle_data[0]))
				timer.wait(2,
					function()
						print(('%s:这些数据越多,游戏的运行效率就会越低下.一般来说不超过100000的话还是比较健康的哦'):format(cmd.getMaidName()))
					end
				)

				local count = 0
				timer.loop(300,
					function()
						count = count + 1

						local handles = {}
						for i = 1, 10 do
							handles[i] = jass.Location(0, 0)
						end
						cmd.handle_data[count] = math.max(unpack(handles)) - 1000000
						for i = 1, 10 do
							jass.RemoveLocation(handles[i])
						end
						print(('\n\n%s:主人,游戏已经过去[%d]分钟了哦,我测试了一下现在游戏中有[%d]个数据'):format(cmd.getMaidName(), count * 5, cmd.handle_data[count]))
						timer.wait(2,
							function()
								print(('%s:在最近5分钟内,游戏中的数据增长了[%d]个,平均每秒增长[%.2f]个!'):format(cmd.getMaidName(), cmd.handle_data[count] - cmd.handle_data[count - 1], (cmd.handle_data[count] - cmd.handle_data[count - 1]) / 300))

								if count > 1 then
									timer.wait(2,
										function()
											print(('%s:和游戏开始的时候相比,游戏中的数据增长了[%d]个,平均每秒增长[%.2f]个!'):format(cmd.getMaidName(), cmd.handle_data[count] - cmd.handle_data[0], (cmd.handle_data[count] - cmd.handle_data[0]) / (count * 300)))
										end
									)
								end
							end
						)
						
					end
				)
				
			end
		)
	end