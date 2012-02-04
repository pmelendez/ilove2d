-----------------------
-- NO: A game of numbers
-- Created: 23.08.08 by Michael Enger
-- Version: 0.2
-- Website: http://www.facemeandscream.com
-- Licence: ZLIB
-----------------------
-- Handles buttons and such.
-----------------------

Sniper = {}
Sniper.__index = Sniper

function Sniper.create(blockhouse)
	
	local temp = {}
	setmetatable(temp, Sniper)
	temp.name = "sniper"
	temp.target = nil
	temp.shoot_time = 0
	temp.blockhouse  = blockhouse

	return temp
	
end
function Sniper:reloadGun()
	self.shoot_time  = love.timer.getMicroTime( )
end
function Sniper:getReloadTime()
	local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	
	if (love.timer.getMicroTime( ) - self.shoot_time  > shoot_time) then
		return 0
	else
		return shoot_time - (love.timer.getMicroTime( ) - self.shoot_time)
	end
end
function Sniper:isReadyShoot()
	local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	return (love.timer.getMicroTime( ) - self.shoot_time  > shoot_time)
end
function Sniper:update(dt)
	
    local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local range = tower_upgrade[weapon][level].range*7
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	 
	if (self.target == nil) then --��ȡһ��target
		for i,e in pairs(state.enemys) do

			if(e.hidden~=true and math.abs(e.x - self.blockhouse.x) <= range and math.abs(e.y - self.blockhouse.y) <= range) then
			    self.target = e
			    e.locked = e.locked + 1
			end
		end
	else
        if(self.target.health <=0 ) then -- ���ٵ�Ŀ�걻������ 
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
  		if(self:isReadyShoot() and math.abs(self.blockhouse.angle - 90 - angle)<5 ) then -- �����ӵ�
   			love.audio.play(sound["sniper_fire"])
   			self:reloadGun()
   			table.insert(state.ballets , Ballet.create(0, self,self.blockhouse.x ,self.blockhouse.y ,self.target))
   			
		end
		
		
		local e = self.target
		if(math.abs(e.x - self.blockhouse.x) > range or math.abs(e.y - self.blockhouse.y) > range) then
		    self.target = nil
		    e.locked = e.locked - 1
		end
		

	end
	
end

