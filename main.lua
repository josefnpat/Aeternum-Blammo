require("socket")-- For socket.gettime()*1000

music = love.audio.newSource("space_party.mp3")
love.audio.play(music)

local playernum = 1

local InitEnemyRate = 1
local BulletSpeed = 600
local ShipSpeed = 150
local InitEnemySpeed = 25
local ShipSize = 128
local BulletSize = 48
local EnemySize = 64

math.randomseed(os.time())
local Ship = {
	Position = {x = 300, y = 300},
	Direction = 0
}
local TitleImage = love.graphics.newImage("title.png")
local ShipImage = love.graphics.newImage("player1.png")
local ShipScale = {x = .5, y = .5}
local ShipOffset = {x = 64,y = 64}

local Bullets = {}
local MissileImage = love.graphics.newImage("Missile.png")
local MineImage = love.graphics.newImage("Mine.png")

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
EnemyImage[1] = love.graphics.newImage("Enemy1.png")
EnemyImage[2] = love.graphics.newImage("Enemy2.png")
EnemyImage[3] = love.graphics.newImage("Enemy3.png")
EnemyImage[4] = love.graphics.newImage("Enemy4.png")
EnemyImage[5] = love.graphics.newImage("Enemy5.png")
EnemyImage[6] = love.graphics.newImage("Enemy6.png")
EnemyImage[7] = love.graphics.newImage("Enemy7.png")
EnemyImage[8] = love.graphics.newImage("Enemy8.png")
local EnemyScale = {x = .5, y = .5}
local EnemyOffset = {x = 32,y = 32}
local EnemyTimer = 0

local hb = {}
hb[0] = love.graphics.newImage("hb_0.png")
hb[1] = love.graphics.newImage("hb_1.png")
hb[2] = love.graphics.newImage("hb_2.png")
hb[3] = love.graphics.newImage("hb_3.png")
hb[4] = love.graphics.newImage("hb_4.png")
hb[5] = love.graphics.newImage("hb_5.png")
hb[6] = love.graphics.newImage("hb_6.png")
hb[7] = love.graphics.newImage("hb_7.png")
hb[8] = love.graphics.newImage("hb_8.png")
hb[9] = love.graphics.newImage("hb_9.png")
hb[10] = love.graphics.newImage("hb_10.png")
hb[11] = love.graphics.newImage("hb_11.png")
hb[12] = love.graphics.newImage("hb_12.png")
hb[13] = love.graphics.newImage("hb_13.png")
hb[14] = love.graphics.newImage("hb_14.png")
hb[15] = love.graphics.newImage("hb_15.png")
hb[16] = love.graphics.newImage("hb_16.png")

local score = 0
local topscore = 0
local EnemyRate = InitEnemyRate
local EnemySpeed = InitEnemySpeed

local bg = love.graphics.newImage("bg.jpg")
local SideImage = love.graphics.newImage("side.png")

local explosion = love.graphics.newImage("explosion.png")

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
local ShootRate = 0.05

function love.keypressed(key)   -- we do not need the unicode, so we can leave it out
  if key == "escape" then
    love.event.push("q")   -- actually causes the app to quit
  elseif key == "1" then
    bullettype = "Missile"
    ShootRate = .05
  elseif key == "2" then
    bullettype = "Mine"
    ShootRate = .25
  elseif key == "f11" then
    love.graphics.toggleFullscreen()
  end
end

local closest

function love.update(dt)
	BulletTimer = BulletTimer + dt
	EnemyTimer = EnemyTimer + dt
	--make bullets move
	for bi,b in pairs(Bullets) do
	  if b.Type == "Missile" then
		  b.Position.x = b.Position.x+(math.cos(b.Direction)*dt*BulletSpeed)
		  b.Position.y = b.Position.y+(math.sin(b.Direction)*dt*BulletSpeed)
		end
		--collision detection with enemies(SIMPLE DISTANCE CHECK COLLISION DETECTION!!!)
		for ei,e in pairs(Enemies) do
			distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
			if distance < (EnemySize/2+BulletSize/2)/2 then
			  if e.health <= 1 then
			    local Boom = {
			      x = e.Position.x,
			      y = e.Position.y,
			      time = socket.gettime()
			    }
  				table.insert(exp,Boom)
  				table.remove(Enemies,ei)
			  else
			    if b.Type == "Missile" then
			      e.health = e.health - 1
			    else
			      e.health = e.health - 5
			    end
			    if e.health < 0 then
			      e.health = 0
			    end
			  end
				table.remove(Bullets,bi)
				score = score + 1
				EnemyRate = EnemyRate - 0.001
				EnemySpeed = EnemySpeed + 0.05
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
		e.Position.x = e.Position.x+(math.cos(e.Direction)*dt*EnemySpeed)
		e.Position.y = e.Position.y+(math.sin(e.Direction)*dt*EnemySpeed)
		e.Direction = math.atan2(e.Position.x-Ship.Position.x,Ship.Position.y-e.Position.y)+math.pi/2

		--collision detection with Ship(SIMPLE DISTANCE CHECK COLLISION DETECTION!!!)
		distance = ((e.Position.x-Ship.Position.x)^2+(e.Position.y-Ship.Position.y)^2)^0.5
		
		if distance < closest.distance then
		  closest.distance = distance
		  closest.x = e.Position.x
		  closest.y = e.Position.y
		end
		
		
		if distance < (EnemySize/2+ShipSize/2)/2 then -- extra div for scale
			Enemies = {}
			Bullets = {}
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
		local spritesel = 9-round(math.log10(math.random(1,100000000))-score*.01)
		if spritesel > 8 then
		  spritesel = 8
		end
	  local Enemy = {
		  Position = {x = math.random(0,1)*800-100, y = math.random(0,800)-100},
		  Direction = 0,
		  sprite = spritesel,
		  health = spritesel*2,
		  maxhealth = spritesel*2
	  }
		table.insert(Enemies,Enemy)
	  local Enemy = {
		  Position = {x = math.random(0,800)-100, y = math.random(0,1)*800-100},
		  Direction = 0,
		  sprite = spritesel,
		  health = spritesel,
		  maxhealth = spritesel
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
	for i,v in pairs(Enemies) do
		local curhealth = round(v.health / v.maxhealth * 16,0)
		love.graphics.draw(hb[curhealth],v.Position.x-16,v.Position.y+16,0,.25,1,0,0)
		love.graphics.draw(EnemyImage[v.sprite],v.Position.x,v.Position.y,v.Direction,EnemyScale.x,EnemyScale.y,EnemyOffset.x,EnemyOffset.y)
	end
	love.graphics.draw(ShipImage,Ship.Position.x,Ship.Position.y,Ship.Direction,ShipScale.x,ShipScale.y,ShipOffset.x,ShipOffset.y)
  love.graphics.print("Player "..playernum, Ship.Position.x + 32, Ship.Position.y + 32)  
  love.graphics.draw(SideImage,600,0)
  love.graphics.print('Score:'..score, 640, 40)
  love.graphics.print('Top Score:'..topscore, 640, 40 + 16)
  love.graphics.print('Weapon:'..bullettype, 640, 40 + 32)
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
