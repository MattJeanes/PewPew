-- PewPew Explosion. Made by Super Llama

function EFFECT:Init(ed)
        self.nrm = ed:GetNormal()
        self.loc = ed:GetOrigin() + self.nrm*10
        self.mag = ed:GetRadius()/50
	if self.mag == 0 then self.mag = 1 end
        self.mag3 = (self.mag-1)/3+1
        self.rrot = math.random(180)
        self.StartTime = CurTime()
        self.Impact = ParticleEmitter(self.loc)
    end
    local glowmat = Material("effects/muzzleflash4")
    local glowmat2 = Material("effects/muzzleflash2")
    function EFFECT:Render()
        self.Life = (CurTime()-self.StartTime)
        render.SetMaterial(glowmat)
        local tim = (0.5*self.mag3)
        local clr = ((tim-self.Life)/tim)*255
        render.DrawSprite(self.loc,500*self.mag,400*self.mag,Color(clr,clr,clr,clr))
        render.SetMaterial(glowmat2)
        render.DrawQuadEasy(self.loc,Vector(0,0,1),400*self.mag,400*self.mag,Color(clr,clr,clr,clr),self.rrot)
    end
    local fireeffects = {"effects/fire_cloud1","effects/fire_cloud2","effects/fire_embers1","particle/particle_smokegrenade","particles/smokey"}
    local asheffects = {"effects/fleck_cement1","effects/fleck_cement2","sprites/light_glow02_add","particle/snow","particle/particle_smokegrenade"}
    function EFFECT:Think()
        self.Life = (CurTime()-self.StartTime)
        --if true then return self.Life<0.5 end
        for i=0,10*self.mag3 do
            local mat = table.Random(fireeffects)
            local vm = 1
            if mat == "particles/smokey" then vm = 3 end
            local fcld = self.Impact:Add(mat,self.loc)
            if fcld then 
                local gup = (math.random(0,2)==2)
                local vel = Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100)) + (gup and self.nrm*200 or vector_origin)*self.mag
                local grav = Vector(math.random(-800,800),math.random(-800,800),math.random(-800,800)) + (gup and self.nrm*-200 or vector_origin)*self.mag
                fcld:SetVelocity(vel)
                fcld:SetGravity(grav)
                fcld:SetLifeTime(0.2);    fcld:SetDieTime(0.4 + self.Life)
                fcld:SetStartAlpha(100);fcld:SetEndAlpha(0)
                fcld:SetStartSize(10*self.mag);  fcld:SetEndSize(80*self.mag + self.Life*40)
                fcld:SetColor(250 - (self.Life*200),100 - (self.Life*50),50,255/vm);
            end
        end
        for i=0,10*self.mag3 do
            local mat = table.Random(fireeffects)
            local vm = 1
            if mat == "particles/smokey" then vm = 2/self.mag3 end
            local fcld = self.Impact:Add(mat,self.loc + Vector(math.random(-30,30),math.random(-30,30),math.random(-30,30))*self.mag)
            if fcld then 
                local gup = (math.random(0,3)==3)
                fcld:SetVelocity(Vector(math.random(-87,87),math.random(-87,87),math.random(-87,87)) + (gup and self.nrm*150 or vector_origin) * vm*self.mag)
                fcld:SetGravity(Vector(math.random(-300,300),math.random(-300,300),math.random(-300,300)) + (gup and self.nrm*-80 or vector_origin)*self.mag)
                fcld:SetLifeTime(0);    fcld:SetDieTime(0.4*vm)
                fcld:SetStartAlpha(100);fcld:SetEndAlpha(0)
                fcld:SetStartSize(50*self.mag3);  fcld:SetEndSize(25)
                local clr = 255 - self.Life*400
                fcld:SetColor(clr/vm,clr/vm,clr/vm,clr);
            end
        end
        if self.Life < 0.2*self.mag3 then
            for i=0,30 do
                local sprk = self.Impact:Add(table.Random(asheffects),self.loc + Vector(math.random(-30,30),math.random(-30,30),math.random(-30,30))*self.mag)
                if sprk then
                    local vel = Vector(math.random(-500,500),math.random(-500,500),math.random(-500,500)) + self.nrm*100*self.mag
                    local grav = Vector(math.random(-800,800),math.random(-800,800),math.random(-800,800)) - Vector(0,0,500)
                    if math.random(0,3)==3 then grav = grav * 2 end
                    sprk:SetVelocity(vel)
                    sprk:SetGravity(grav)
                    sprk:SetLifeTime(0);  sprk:SetDieTime(math.max((800-(vel+grav):Length())/250),0.3);
                    sprk:SetStartAlpha(255);sprk:SetEndAlpha(0);
                    sprk:SetStartSize(math.random(2,5));  sprk:SetEndSize(2);
                    sprk:SetBounce(0.3);
                    sprk:SetAirResistance(0.5);
                    sprk:SetCollide(true);
                    sprk:SetRollDelta(math.Rand(-15,15))
                    local rash = math.random(100,255)
                    local ash = math.random(0,200)
                    sprk:SetColor(rash,ash,ash,255);
                end 
            end 
        end
        if self.Life > 0.5 then self.Impact:Finish() return false end
        return true
    end