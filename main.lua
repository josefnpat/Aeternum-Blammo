--this you can change if you want
local ShootRate = 0.05--how smaller how faster
local InitEnemieRate = .2--how smaller how faster
local BulletSpeed = 600--how bigger how faster
local ShipSpeed = 150--how bigger how faster
local InitEnemieSpeed = 50--how bigger how faster
local ShipSize = 64--how bigger how bigger
local BulletSize = 32--how bigger how bigger
local EnemieSize = 51--how bigger how bigger
--do not change things below

math.randomseed(os.time())
local Ship = {
	Position = {x = 400, y = 300},
	Direction = 0
}
local ShipImage = love.graphics.newImage("Ship.png")
local ShipScale = {x = ShipSize/love.graphics.newImage("Ship.png"):getWidth(), y = ShipSize/love.graphics.newImage("Ship.png"):getHeight()}
local ShipOffset = {x = love.graphics.newImage("Ship.png"):getWidth()/2,y = love.graphics.newImage("Ship.png"):getHeight()/2}

local Bullets = {}
local BulletImage = love.graphics.newImage("Bullet.png")
local BulletScale = {x = BulletSize/BulletImage:getWidth(), y = BulletSize/BulletImage:getHeight()}
local BulletOffset = {x = BulletImage:getWidth()/2,y = BulletImage:getHeight()/2}
local BulletTimer = 0

local Enemies = {}
local EnemieImage1 = love.graphics.newImage("Enemy1.png")
local EnemieImage2 = love.graphics.newImage("Enemy2.png")
local EnemieImage3 = love.graphics.newImage("Enemy3.png")
local EnemieImage4 = love.graphics.newImage("Enemy4.png")
local EnemieImage5 = love.graphics.newImage("Enemy5.png")
local EnemieImage6 = love.graphics.newImage("Enemy6.png")
local EnemieImage7 = love.graphics.newImage("Enemy7.png")
local EnemieImage8 = love.graphics.newImage("Enemy8.png")
local EnemieScale = {x = EnemieSize/EnemieImage1:getWidth(), y = EnemieSize/EnemieImage1:getHeight()}
local EnemieOffset = {x = EnemieImage1:getWidth()/2,y = EnemieImage1:getHeight()/2}
local EnemieTimer = 0

local score = 0
local topscore = 0
local EnemieRate = InitEnemieRate
local EnemieSpeed = InitEnemieSpeed

local bg = love.graphics.newImage("bg.png")

function love.update(dt)
	BulletTimer = BulletTimer + dt
	EnemieTimer = EnemieTimer + dt
	--make bullets move
	for bi,b in pairs(Bullets) do
		b.Position.x = b.Position.x+(math.cos(b.Direction)*dt*BulletSpeed)
		b.Position.y = b.Position.y+(math.sin(b.Direction)*dt*BulletSpeed)
		--collision detection with enemies(SIMPLE DISTANCE CHECK COLLISION DETECTION!!!)
		for ei,e in pairs(Enemies) do
			distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
			if distance < EnemieSize/2+BulletSize/2 then
				table.remove(Enemies,ei)
				table.remove(Bullets,bi)
				score = score + 1
				EnemieRate = EnemieRate - 0.0002
				EnemieSpeed = EnemieSpeed + 0.1
			end
		end
		--check if out of screen
		if b.Position.x < 0 or b.Position.x > 800 or b.Position.y < 0 or b.Position.y > 600 then
			table.remove(Bullets,bi)
		end
	end

	--make Enemies move
	for ei,e in pairs(Enemies) do
		e.Position.x = e.Position.x+(math.cos(e.Direction)*dt*EnemieSpeed)
		e.Position.y = e.Position.y+(math.sin(e.Direction)*dt*EnemieSpeed)
		e.Direction = math.atan2(e.Position.x-Ship.Position.x,Ship.Position.y-e.Position.y)+math.pi/2

		--collision detection with Ship(SIMPLE DISTANCE CHECK COLLISION DETECTION!!!)
		distance = ((e.Position.x-Ship.Position.x)^2+(e.Position.y-Ship.Position.y)^2)^0.5
		if distance < EnemieSize/2+ShipSize/2 then
			Enemies = {}
			Bullets = {}
			Ship.Position.x = 400
			Ship.Position.y = 300
			EnemieRate = InitEnemieRate
			EnemieSpeed = InitEnemieSpeed
			if score > topscore then
 			 topscore = score
			end
			score = 0
		end
	end
	--direct ship to mouse
	Ship.Direction = math.atan2(love.mouse.getX()-Ship.Position.x,Ship.Position.y-love.mouse.getY())-math.pi/2
	--make ship move
	if love.mouse.isDown("l") then
		Ship.Position.x = Ship.Position.x+(math.cos(Ship.Direction)*dt*ShipSpeed)
		Ship.Position.y = Ship.Position.y+(math.sin(Ship.Direction)*dt*ShipSpeed)
	end
	--make bullets
	if love.mouse.isDown("r") then
		if BulletTimer > ShootRate then
			BulletTimer = 0
			local Bullet = {
				Position = {x = Ship.Position.x, y = Ship.Position.y},
				Direction = Ship.Direction
			}
			table.insert(Bullets,Bullet)
		end
	end
	--make Enemy
	if EnemieTimer > EnemieRate then
		EnemieTimer = 0
		local Enemy = {
			Position = {x = math.random(0,1)*800, y = math.random(0,600)},
			Direction = 0,
			sprite = math.random(1,8)
		}
		table.insert(Enemies,Enemy)
		
		local Enemy = {
			Position = {x = math.random(0,800), y = math.random(0,1)*600},
			Direction = 0
		}
		table.insert(Enemies,Enemy)
	end
end
function love.draw()

	love.graphics.draw(bg,Ship.Position.x/5-800,Ship.Position.y/5-600,0,1,1,0,0)
	for i,v in pairs(Bullets) do
		love.graphics.draw(BulletImage,v.Position.x,v.Position.y,v.Direction,BulletScale.x,BulletScale.y,BulletOffset.x,BulletOffset.y)
	end
	for i,v in pairs(Enemies) do
	  if v.sprite == 1 then
	    cur = EnemieImage1
	  elseif v.sprite == 2 then
	    cur = EnemieImage2
	  elseif v.sprite == 3 then
	    cur = EnemieImage3
	  elseif v.sprite == 4 then
	    cur = EnemieImage4
	  elseif v.sprite == 5 then
	    cur = EnemieImage5
	  elseif v.sprite == 6 then
	    cur = EnemieImage6
	  elseif v.sprite == 7 then
	    cur = EnemieImage7
	  else
  	  cur = EnemieImage8
	  end
		love.graphics.draw(cur,v.Position.x,v.Position.y,v.Direction,EnemieScale.x,EnemieScale.y,EnemieOffset.x,EnemieOffset.y)
	end
	love.graphics.draw(ShipImage,Ship.Position.x,Ship.Position.y,Ship.Direction,ShipScale.x,ShipScale.y,ShipOffset.x,ShipOffset.y)
  love.graphics.print('Score:'..score, Ship.Position.x + 32, Ship.Position.y + 32)
  love.graphics.print('Top Score:'..topscore, Ship.Position.x + 32, Ship.Position.y + 48)
end


