-----------------------
-- NO: A game of numbers
-- Created: 23.08.08 by Michael Enger
-- Version: 0.2
-- Website: http://www.facemeandscream.com
-- Licence: ZLIB
-----------------------
-- Handles buttons and such.

Rocket = {}
Rocket.__index = Rocket

function Rocket.create(blockhouse)
	
	local temp = {}
	setmetatable(temp, Rocket)
	temp.name = "rocket"
	--temp.hover = false -- whether the mouse is hovering over the button
	--temp.click = false -- whether the mouse has been clicked on the button
	temp.buy_cost = 20
	temp.damage = 10
	temp.target = nil
	temp.shoot_time = 0
	temp.update_time = 0
	temp.blockhouse  = blockhouse
	return temp
	
end
function Rocket:reloadGun()
	self.shoot_time  = love.timer.getMicroTime( )
end
function Rocket:getReloadTime()
	local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	
	if (love.timer.getMicroTime( ) - self.shoot_time  > shoot_time) then
		return 0
	else
		return shoot_time - (love.timer.getMicroTime( ) - self.shoot_time)
	end
end
function Rocket:isReadyShoot()
	local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	return (love.timer.getMicroTime( ) - self.shoot_time  > shoot_time)
end
function Rocket:draw()
	
	love.graphics.setFont(font["large"])
	if self.hover then love.graphics.setColor(color["main"])
	else love.graphics.setColor(color["menu_text"]) end
	love.graphics.draw(self.text, self.x, self.y)
	
end

function Rocket:update(dt)
	
    local weapon = self.blockhouse.weapon
    local level = self.blockhouse.level
	local range = tower_upgrade[weapon][level].range * 7
	local shoot_time = tower_upgrade[weapon][level].shoot_time
	local update_time = tower_upgrade[weapon][level].update_time
	
   
	if (self.target == nil) then --��ȡһ��target

		for i,e in pairs(state.enemys) do
			if (e.hidden~=true and e.number ~=6 -- ���Ƿɻ�
			and  math.abs(e.x - self.blockhouse.x) <= range and math.abs(e.y - self.blockhouse.y) <= range) then
			    self.target = e
			    e.locked = e.locked + 1
				break
			end
		end
 	end
    local e = self.target
    if(e ~= nil) then
		if(e.health <=0 ) then -- ���ٵ�Ŀ�걻������
			e.locked = e.locked - 1
			self.target = nil
			return
		end
		if(math.abs(e.x - self.blockhouse.x) > range or
			math.abs(e.y - self.blockhouse.y) > range) then -- ������Χ
    		e.locked = e.locked - 1
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
   			love.audio.play(sound["rocket_fire"])
      		self:reloadGun()
   			table.insert(state.ballets , Ballet.create(1, self,self.blockhouse.x ,self.blockhouse.y ,self.target))
		end

	end
	
end

function Rocket:mousepressed(x, y, button)
	
	if self.hover then
		if audio then
			love.audio.play(sound["click"])
		end
		return true
	end
	
	return false
	
end
