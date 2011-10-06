require("socket")-- For socket.gettime()*1000

music = love.audio.newSource("space_party.mp3")
love.audio.play(music)

--this you can change if you want
local ShootRate = 0.05--how smaller how faster
local InitEnemieRate = 2--how smaller how faster
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
local EnemieScale = {x = EnemieSize/EnemyImage[1]:getWidth(), y = EnemieSize/EnemyImage[1]:getHeight()}
local EnemieOffset = {x = EnemyImage[1]:getWidth()/2,y = EnemyImage[1]:getHeight()/2}
local EnemieTimer = 0

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
local EnemieRate = InitEnemieRate
local EnemieSpeed = InitEnemieSpeed

local bg = love.graphics.newImage("bg.png")

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
			  if e.health == 1 then
			    local Boom = {
			      x = e.Position.x,
			      y = e.Position.y,
			      time = socket.gettime()
			    }
  				table.insert(exp,Boom)
  				table.remove(Enemies,ei)
			  else
			    e.health = e.health - 1
			  end
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
			exp = {}
			Ship.Position.x = 400
			Ship.Position.y = 300
			EnemieRate = InitEnemieRate
			EnemieSpeed = InitEnemieSpeed
			if score > topscore then
 			 topscore = score
			end
			score = 0
			love.audio.stop()
			love.audio.play(music)
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
		local spritesel = 9-round(math.log10(math.random(1,100000000))-score*.01)
		if spritesel > 8 then
		  spritesel = 8
		end
	  local Enemy = {
		  Position = {x = math.random(0,1)*1000-100, y = math.random(0,800)-100},
		  Direction = 0,
		  sprite = spritesel,
		  health = spritesel*2,
		  maxhealth = spritesel*2
	  }
		table.insert(Enemies,Enemy)
	  local Enemy = {
		  Position = {x = math.random(0,1000)-100, y = math.random(0,1)*800-100},
		  Direction = 0,
		  sprite = spritesel,
		  health = spritesel*2,
		  maxhealth = spritesel*2
	  }
		table.insert(Enemies,Enemy)
	end
end
function love.draw()
	love.graphics.draw(bg,Ship.Position.x/5-800,Ship.Position.y/5-600,0,1,1,0,0)
	for i,v in pairs(exp) do
    cur = round ( (socket.gettime() - v.time) * 10 )
    if cur > 15 then
      cur = 15
      table.remove(exp,i)
    end
		love.graphics.drawq(explosion,quad[cur],v.x-51/2,v.y-51/2)
	end
	for i,v in pairs(Bullets) do
	  cur = (round(socket.gettime() * 10) + i) % 5 
		love.graphics.drawq(BulletImage,bulletquad[cur],v.Position.x,v.Position.y,v.Direction,BulletScale,BulletScale,BulletOffset,BulletOffset)
	end
	for i,v in pairs(Enemies) do
		love.graphics.draw(EnemyImage[v.sprite],v.Position.x,v.Position.y,v.Direction,EnemieScale.x,EnemieScale.y,EnemieOffset.x,EnemieOffset.y)
		local curhealth = round(v.health / v.maxhealth * 16,0)
		love.graphics.draw(hb[curhealth],v.Position.x,v.Position.y+51,0,.35,1,EnemieOffset.x,EnemieOffset.y)
	end
	love.graphics.draw(ShipImage,Ship.Position.x,Ship.Position.y,Ship.Direction,ShipScale.x,ShipScale.y,ShipOffset.x,ShipOffset.y)
  love.graphics.print('Score:'..score, Ship.Position.x + 32, Ship.Position.y + 32)
  love.graphics.print('Top Score:'..topscore, Ship.Position.x + 32, Ship.Position.y + 48)
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
