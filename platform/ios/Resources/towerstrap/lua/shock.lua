-----------------------
-- NO: A game of numbers
-- Created: 23.08.08 by Michael Enger
-- Version: 0.2
-- Website: http://www.facemeandscream.com
-- Licence: ZLIB
-----------------------
-- Handles buttons and such.
-----------------------

Shock = {}
Shock.__index = Shock

function Shock.create(blockhouse)
	
 local temp = {}
	setmetatable(temp, Shock)
	temp.target = nil
	temp.shoot_time = 0
	temp.blockhouse  = blockhouse

	return temp
	
end

function Shock:update(dt)

    local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local range = tower_upgrade[weapon][level].range*7
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	if(self.shoot_time >0) then
		self.shoot_time = self.shoot_time - dt 
	end
	if (self.target == nil) then --��ȡһ��target
		local lastwanttarget = nil
		for i,e in pairs(state.enemys) do

			if(e.hidden~=true and math.abs(e.x - self.blockhouse.x) <= range and math.abs(e.y - self.blockhouse.y) <= range) then
			    if(lastwanttarget == nil) then
			    	lastwanttarget = e
			    end
			    if(e.slowly == false) then
					self.target = e
			    	e.locked = e.locked + 1
			    	break
			    end
			end
		end
		if (self.target == nil and lastwanttarget ~= nil) then
			self.target = lastwanttarget
			lastwanttarget.locked = lastwanttarget.locked + 1
		end
	else
        if(self.target.health <=0 or self.target.slowly == true) then -- ���ٵ�Ŀ�걻�����˻������˼��ٵ� 
			self.target = nil
			return
		end
		local dx = self.target.x - self.blockhouse.x
		local dy = self.target.y - self.blockhouse.y
		local angle = (270 + math.atan2(dy, dx)*180/math.pi)%360
		if(self.blockhouse.angle < angle ) then
			self.blockhouse.angle =  angle + 90 * dt + 90
  		end
		if(self.blockhouse.angle > angle ) then
			self.blockhouse.angle = angle - 90 * dt  + 90
    	end
  		if(self.shoot_time <=0 and math.abs(self.blockhouse.angle - 90 - angle)<5 ) then -- �����ӵ�
   			love.audio.play(sound["slowdown_fire"])
   			self.shoot_time  = shoot_time
   			table.insert(state.ballets , Ballet.create(3, self,self.blockhouse.x ,self.blockhouse.y ,self.target))

		end


		local e = self.target
		if(math.abs(e.x - self.blockhouse.x) > range or math.abs(e.y - self.blockhouse.y) > range) then
		    self.target = nil
		    e.locked = e.locked - 1
		end


	end

end
