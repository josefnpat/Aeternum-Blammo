require("socket")-- For socket.gettime()*1000

music = love.audio.newSource("assets/space_party.mp3")
love.audio.play(music)

local playernum = 1

local InitEnemyRate = 1
local BulletSpeed = 300
local ShipSpeed = 150
local InitEnemySpeed = 25
local ShipSize = 128
local BulletSize = 48

math.randomseed(os.time())
local Ship = {
	Position = {x = 300, y = 300},
	Direction = 0
}
local TitleImage = love.graphics.newImage("assets/title.png")
local ShipImage = love.graphics.newImage("assets/player1.png")
local ShipScale = {x = .5, y = .5}
local ShipOffset = {x = ShipImage:getWidth()/2,y = ShipImage:getHeight()/2}

local RepairImage = love.graphics.newImage("assets/repair.png")
local SpeedImage = love.graphics.newImage("assets/speed.png")
local Items = {}

local Bullets = {}
local MissileImage = love.graphics.newImage("assets/Missile.png")
local MineImage = love.graphics.newImage("assets/Mine.png")

local bulletquad = {}
bulletquad[0] = love.graphics.newQuad(0,0,48,48,240,48)
bulletquad[1] = love.graphics.newQuad(48,0,48,48,240,48)
bulletquad[2] = love.graphics.newQuad(96,0,48,48,240,48)
bulletquad[3] = love.graphics.newQuad(144,0,48,48,240,48)
bulletquad[4] = love.graphics.newQuad(192,0,48,48,240,48)
bulletquad[5] = love.graphics.newQuad(240,0,48,48,240,48)

local BulletScale = 1
local BulletOffset = 24
local BulletTimer = 0

local Enemies = {}
local EnemyImage = {}
EnemyImage[1] = love.graphics.newImage("assets/Enemy1.png")
EnemyImage[2] = love.graphics.newImage("assets/Enemy2.png")
EnemyImage[3] = love.graphics.newImage("assets/Enemy3.png")
EnemyImage[4] = love.graphics.newImage("assets/Enemy4.png")
EnemyImage[5] = love.graphics.newImage("assets/Enemy5.png")
EnemyImage[6] = love.graphics.newImage("assets/Enemy6.png")
EnemyImage[7] = love.graphics.newImage("assets/Enemy7.png")
EnemyImage[8] = love.graphics.newImage("assets/Enemy8.png")
local EnemyScale = {x = 1, y = 1}
local EnemyOffset = {}
for variable = 1, 8, 1 do
  EnemyOffset[variable] = {x = EnemyImage[variable]:getWidth()/2,y = EnemyImage[variable]:getHeight()/2}
end
local EnemySize = {}
for variable = 1, 8, 1 do
  EnemySize[variable] = EnemyImage[variable]:getHeight()
end

local EnemyTimer = 0

local hb = {}
hb[0] = love.graphics.newImage("assets/hb_0.png")
hb[1] = love.graphics.newImage("assets/hb_1.png")
hb[2] = love.graphics.newImage("assets/hb_2.png")
hb[3] = love.graphics.newImage("assets/hb_3.png")
hb[4] = love.graphics.newImage("assets/hb_4.png")
hb[5] = love.graphics.newImage("assets/hb_5.png")
hb[6] = love.graphics.newImage("assets/hb_6.png")
hb[7] = love.graphics.newImage("assets/hb_7.png")
hb[8] = love.graphics.newImage("assets/hb_8.png")
hb[9] = love.graphics.newImage("assets/hb_9.png")
hb[10] = love.graphics.newImage("assets/hb_10.png")
hb[11] = love.graphics.newImage("assets/hb_11.png")
hb[12] = love.graphics.newImage("assets/hb_12.png")
hb[13] = love.graphics.newImage("assets/hb_13.png")
hb[14] = love.graphics.newImage("assets/hb_14.png")
hb[15] = love.graphics.newImage("assets/hb_15.png")
hb[16] = love.graphics.newImage("assets/hb_16.png")

local score = 0
local topscore = 0
local EnemyRate = InitEnemyRate
local EnemySpeed = InitEnemySpeed
local PlayerHealth = 100

local bg = love.graphics.newImage("assets/bg.jpg")
local SideImage = love.graphics.newImage("assets/side.png")

local explosion = love.graphics.newImage("assets/explosion.png")

quad = {}

quad[0] = love.graphics.newQuad(0,0,64,64,256,256)
quad[1] = love.graphics.newQuad(64,0,64,64,256,256)
quad[2] = love.graphics.newQuad(128,0,64,64,256,256)
quad[3] = love.graphics.newQuad(192,0,64,64,256,256)

quad[4] = love.graphics.newQuad(0,64,64,64,256,256)
quad[5] = love.graphics.newQuad(64,64,64,64,256,256)
quad[6] = love.graphics.newQuad(128,64,64,64,256,256)
quad[7] = love.graphics.newQuad(192,64,64,64,256,256)

quad[8] = love.graphics.newQuad(0,128,64,64,256,256)
quad[9] = love.graphics.newQuad(64,128,64,64,256,256)
quad[10] = love.graphics.newQuad(128,128,64,64,256,256)
quad[11] = love.graphics.newQuad(192,128,64,64,256,256)

quad[12] = love.graphics.newQuad(0,192,64,64,256,256)
quad[13] = love.graphics.newQuad(64,192,64,64,256,256)
quad[14] = love.graphics.newQuad(128,192,64,64,256,256)
quad[15] = love.graphics.newQuad(192,192,64,64,256,256)

local exp = {}

local title_start = socket.gettime()

local bullettype = "Missile"
local ShootRateMult = 0.25
local ShootRate = 0

function update_shoot_rate ()
  if bullettype == "Missile" then
    base_rate = 0.5
  else
    base_rate = 1
  end
  ShootRate = base_rate * (1/(math.log10(ShootRateMult+1)*10))
end

update_shoot_rate()

function love.keypressed(key)   -- we do not need the unicode, so we can leave it out
  if key == "escape" then
    love.event.push("q")   -- actually causes the app to quit
  elseif key == "1" then
    bullettype = "Missile"
    update_shoot_rate()
  elseif key == "2" then
    bullettype = "Mine"
    update_shoot_rate()
  elseif key == "f11" then
    love.graphics.toggleFullscreen()
  end
end

local closest

function love.update(dt)
	BulletTimer = BulletTimer + dt
	EnemyTimer = EnemyTimer + dt
	for ii,i in pairs(Items) do
		distance = ((i.x-Ship.Position.x)^2+(i.y-Ship.Position.y)^2)^0.5
		if distance < (ShipSize/2+BulletSize/2)*EnemyScale.x then
		  if i.type == "Health" then
  		  PlayerHealth = PlayerHealth + round((100 - PlayerHealth) / 2)
  		else
  		  ShootRateMult = ShootRateMult + 0.25
	      update_shoot_rate()
  		end
			table.remove(Items,ii)
		end
	end	
	--make bullets move
	for bi,b in pairs(Bullets) do
	  if b.Type == "Missile" then
		  b.Position.x = b.Position.x+(math.cos(b.Direction)*dt*BulletSpeed)
		  b.Position.y = b.Position.y+(math.sin(b.Direction)*dt*BulletSpeed)
		end
		--collision detection with enemies(SIMPLE DISTANCE CHECK COLLISION DETECTION!!!)
		for ei,e in pairs(Enemies) do
			distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
			if distance < (EnemySize[e.sprite]/2+BulletSize/2)*EnemyScale.x then
			  if e.health < 1 then
			    local Boom = {
			      x = e.Position.x,
			      y = e.Position.y,
			      time = socket.gettime()
			    }
  				table.insert(exp,Boom)
  				if math.random(1,10) == 1 then
    				local Item = {
    				  type = "Speed",
		          x = e.Position.x,
		          y = e.Position.y
    				}
    				table.insert(Items,Item)

  				elseif math.random(1,10) == 1 then
    				local Item = {
    				  type = "Health",
    				  amount = 10,
			        x = e.Position.x,
			        y = e.Position.y
    				}
    				table.insert(Items,Item)
    		  end
  				table.remove(Enemies,ei)
			  else
			    if b.Type == "Missile" then
			      e.health = e.health - 10
			    else
			      e.health = e.health - 50
			    end
			    if e.health < 0 then
			      e.health = 0
			    end
			  end
				table.remove(Bullets,bi)
				score = score + 1
				EnemyRate = EnemyRate - 0.00005
				EnemySpeed = EnemySpeed + 0.005
			end
		end
		--check if out of screen
		if b.Position.x < 0 or b.Position.x > 600 or b.Position.y < 0 or b.Position.y > 600 then
			table.remove(Bullets,bi)
		end
	end

  closest = {
    distance = 1000,
    x=0,
    y=0
  }
	--make Enemies move
	for ei,e in pairs(Enemies) do
	  local temp_width = EnemyImage[e.sprite]:getWidth()
		e.Position.x = e.Position.x+(math.cos(e.Direction)*dt*EnemySpeed/(temp_width*1.5)*32)
		e.Position.y = e.Position.y+(math.sin(e.Direction)*dt*EnemySpeed/(temp_width*1.5)*32)
		e.Direction = math.atan2(e.Position.x-Ship.Position.x,Ship.Position.y-e.Position.y)+math.pi/2

		--collision detection with Ship(SIMPLE DISTANCE CHECK COLLISION DETECTION!!!)
		distance = ((e.Position.x-Ship.Position.x)^2+(e.Position.y-Ship.Position.y)^2)^0.5
		
		if distance < closest.distance then
		  closest.distance = distance
		  closest.x = e.Position.x
		  closest.y = e.Position.y
		end
		
		if distance < (EnemySize[e.sprite]/2+ShipSize/2)*EnemyScale.x then -- extra div for scale
		  PlayerHealth = PlayerHealth - e.health
		  e.health = 0
		  if PlayerHealth <= 0 then
  		  ShootRateMult = 0.25
  		  update_shoot_rate ()
  		  PlayerHealth = 100
			  Enemies = {}
			  Bullets = {}
			  Items = {}
			  exp = {}
			  Ship.Position.x = 300
			  Ship.Position.y = 300
			  EnemyRate = InitEnemyRate
			  EnemySpeed = InitEnemySpeed
			  if score > topscore then
   			 topscore = score
			  end
			  score = 0
			  bullettype = "Missile"
			  ShootRate = 0.05
			  love.audio.stop()
			  love.audio.play(music)
			  title_start = socket.gettime()
			end
		end
	end
	--direct ship to mouse
	Ship.Direction = math.atan2(love.mouse.getX()-Ship.Position.x,Ship.Position.y-love.mouse.getY())-math.pi/2
-- Best ever test
--[[
	if closest.distance > 0 then
  	Ship.Direction = math.atan2(closest.x-Ship.Position.x,Ship.Position.y-closest.y)-math.pi/2
	end
]]--
	--make ship move
	if love.mouse.isDown("l") then
		Ship.Position.x = Ship.Position.x+(math.cos(Ship.Direction)*dt*ShipSpeed)
		if Ship.Position.x < 0 then
		  Ship.Position.x = 0
		elseif Ship.Position.x > 600 then
		  Ship.Position.x = 600
		end
		Ship.Position.y = Ship.Position.y+(math.sin(Ship.Direction)*dt*ShipSpeed)
		if Ship.Position.y < 0 then
		  Ship.Position.y = 0
		elseif Ship.Position.y > 600 then
		  Ship.Position.y = 600
		end
	end
	--make bullets
	if love.mouse.isDown("r") then
		if BulletTimer > ShootRate then
			BulletTimer = 0
	    local Bullet = {
		    Position = {x = Ship.Position.x, y = Ship.Position.y},
		    Direction = Ship.Direction,
		    Type = bullettype
	    }
			table.insert(Bullets,Bullet)
		end
	end
	--make Enemy
	if EnemyTimer > EnemyRate then
		EnemyTimer = 0
		--local spritesel = 9-round(math.log10(math.random(1,100000000))-round(math.log10(score))*.01)
    spritesel = 1
    local basemult = 100
    if math.random(1,2) == 1 and score > 32 then
      spritesel = 2
    end
    if math.random(1,4) == 1  and score > 64 then
      spritesel = 3
    end
    if math.random(1,8) == 1  and score > 128 then
      spritesel = 4
    end
    if math.random(1,16) == 1 and score > 256 then
      spritesel = 5
    end
    if math.random(1,32) == 1 and score > 512 then
      spritesel = 6
    end
    if math.random(1,64) == 1 and score > 1024 then
      spritesel = 7
    end
    if math.random(1,128) == 1 and score > 2048 then
      spritesel = 8
    end
		
		if spritesel > 8 then
		  spritesel = 8
		end
		if spritesel < 1 then
		  spritesel = 1
		end
	  local Enemy = {
		  Position = {x = math.random(0,1)*800-100, y = math.random(0,800)-100},
		  Direction = 0,
		  sprite = spritesel,
		  health = spritesel*spritesel*10,
		  maxhealth = spritesel*spritesel*10
	  }
		table.insert(Enemies,Enemy)
	  local Enemy = {
		  Position = {x = math.random(0,800)-100, y = math.random(0,1)*800-100},
		  Direction = 0,
		  sprite = spritesel,
		  health = spritesel*spritesel*10,
		  maxhealth = spritesel*spritesel*10
	  }
		table.insert(Enemies,Enemy)
	end
end
function love.draw()
  love.graphics.setColor(255, 255, 255, 192)
	love.graphics.draw(bg,Ship.Position.x/8-600,Ship.Position.y/8-600,0,4,4,0,0)
  love.graphics.setColor(255, 255, 255, 128)
	love.graphics.draw(bg,Ship.Position.x/4-600,Ship.Position.y/4-600,0,2,2,0,0)
  love.graphics.setColor(255, 255, 255, 64)
	love.graphics.draw(bg,Ship.Position.x/2-600,Ship.Position.y/2-600,0,1,1,0,0)
  love.graphics.setColor(255, 255, 255, 255)
	for i,v in pairs(exp) do
    cur = round ( (socket.gettime() - v.time) * 10 )
    if cur > 15 then
      cur = 15
      table.remove(exp,i)
    end
		love.graphics.drawq(explosion,quad[cur],v.x-32,v.y-32)
	end
	for i,v in pairs(Bullets) do
	  cur = (round(socket.gettime() * 10) + i) % 5 
	  if v.Type == "Missile" then
  	  curimage = MissileImage
	  else
	    curimage = MineImage
	  end
		love.graphics.drawq(curimage,bulletquad[cur],v.Position.x,v.Position.y,v.Direction,BulletScale,BulletScale,BulletOffset,BulletOffset)
	end
	for ii,i in pairs(Items) do
	  if i.type == "Health" then
  	  love.graphics.draw(RepairImage,i.x,i.y,0,1,1,24,24)
  	else
  	  love.graphics.draw(SpeedImage,i.x,i.y,0,1,1,24,24)
  	end
	end
	for i,v in pairs(Enemies) do
		local curhealth = round(v.health / v.maxhealth * 16,0)
		--EnemyOffset[v.sprite].x
		love.graphics.draw(hb[curhealth],v.Position.x-EnemyImage[v.sprite]:getWidth()/2,v.Position.y+EnemyImage[v.sprite]:getHeight()/2+4,0,EnemyImage[v.sprite]:getWidth()/128,1,0,0)
		love.graphics.draw(EnemyImage[v.sprite],v.Position.x,v.Position.y,v.Direction,EnemyScale.x,EnemyScale.y,EnemyOffset[v.sprite].x,EnemyOffset[v.sprite].y)
	end
	love.graphics.draw(ShipImage,Ship.Position.x,Ship.Position.y,Ship.Direction,ShipScale.x,ShipScale.y,ShipOffset.x,ShipOffset.y)
	local curhealth = round(PlayerHealth / 100 * 16,0)
  love.graphics.draw(SideImage,600,0)
  love.graphics.print('Score:'..score, 640, 40)
  love.graphics.print('Top Score:'..topscore, 640, 40 + 16)
  love.graphics.print('Weapon:'..bullettype, 640, 40 + 32)
  love.graphics.print('Fire Rate:'..round(1/ShootRate,2).."/s", 640, 40 + 48)
  love.graphics.print('Health:'..PlayerHealth.."/100", 640, 40 + 64)
	love.graphics.draw(hb[curhealth],640,40 + 80,math.pi/2,3,16,0,8)
  love.graphics.setColor(255, 255, 255, math.random(64,192))
	if title_start + 3 > socket.gettime() then
	  love.graphics.draw(TitleImage,math.random(-5,5),math.random(-5,5)+200,0,.75,.75)
	end
  love.graphics.setColor(255, 255, 255, 255)
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
