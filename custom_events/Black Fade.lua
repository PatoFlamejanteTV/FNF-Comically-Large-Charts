-- Event notes hooks
function onEvent(name,value1,value2)
	if name == 'Black Fade' then
		if value1 == 'True' then
			if value2 == null then
				value2 = 1
			end
			makeLuaSprite('Black','',-200,-200)
			makeGraphic('Black',1920, 1080, '000000')
			setProperty('Black.alpha',0)
			setScrollFactor('Black',0,0)
			addLuaSprite('Black',true)

			doTweenAlpha('BlackFade','Black', 1, value2)
		end
		if value1 == 'False' then
			if value2 == null then
				value2 = 1
			end
			doTweenAlpha('BlackFadeOut','Black', 0, value2)
		end
	end
end


