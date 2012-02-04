-----------------------
-- NO: A game of numbers
-- Created: 23.08.08 by Michael Enger
-- Version: 0.2
-- Website: http://www.facemeandscream.com
-- Licence: ZLIB
-----------------------
-- Handles buttons and such.
-----------------------

EarthQuake = {}
EarthQuake.__index = EarthQuake

function EarthQuake.create(blockhouse)
	
	local temp = {}
	setmetatable(temp, EarthQuake)
	temp.name = "EarthQuake"
	temp.target = nil
	temp.shoot_time = 0
	temp.blockhouse  = blockhouse

	return temp
	
end
function EarthQuake:reloadGun()
	self.shoot_time  = love.timer.getMicroTime( )
end
function EarthQuake:getReloadTime()
	local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	
	if (love.timer.getMicroTime( ) - self.shoot_time  > shoot_time) then
		return 0
	else
		return shoot_time - (love.timer.getMicroTime( ) - self.shoot_time)
	end
end
function EarthQuake:isReadyShoot()
	local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	return (love.timer.getMicroTime( ) - self.shoot_time  > shoot_time)
end
function EarthQuake:update(dt)
	
	local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local range = tower_upgrade[weapon][level].range*7
	local shoot_time = tower_upgrade[weapon][level].shoot_time
 
	if (self.target == nil) then --��ȡһ��target
		for i,e in pairs(state.enemys) do

			if (e.hidden~=true and e.number ~=6 -- ���Ƿɻ�
			and (math.abs(e.x - self.blockhouse.x) <= range and math.abs(e.y - self.blockhouse.y) <= range) ) then
			    self.target = e
			    e.locked = e.locked + 1
			end
		end
	else
        if(self.target.health <=0 ) then -- ���ٵ�Ŀ�걻������ 
			self.target = nil
			return
		end

  		if(self:isReadyShoot() ) then -- ������� 
   			love.audio.play(sound["earthquake_fire"])
   			self:reloadGun()
   			self.blockhouse.earthquake_action_r = 6
   			ballet =  Ballet.create(5, self,self.blockhouse.x ,self.blockhouse.y ,self.target)
   			ballet.live = 0

   			table.insert(state.ballets , ballet)
   			-- �������� 
  		end


		local e = self.target
		if(math.abs(e.x - self.blockhouse.x) > range or math.abs(e.y - self.blockhouse.y) > range) then
		    self.target = nil
		    e.locked = e.locked - 1
		end
		

	end
	
end

