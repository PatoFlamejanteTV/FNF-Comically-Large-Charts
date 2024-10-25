

LerpUtils = {}


function LerpUtils:new(a, b, c, d, e, f, g)
  local lerp = {
    count = 0,
    startValue = a or 0,
    endValue = b or 100,
    currentValue = 0,
    duration = c or 10,
    ease = d or 'linear',
    onLerp = e or function() end,
    onComplete = {
      triggeredEnd = false,
      onComplete = f or function() end,
    },
    onFrame = g or function() end,
    percent = 0,
    simplePercent = 0
  }
  setmetatable(lerp, self);
  self.__index = self
  return lerp
end


function LerpUtils:reset()
  self.count = 0
  self.currentValue = self.startValue
  self.onComplete.triggeredEnd = false
end

function LerpUtils:update(elapsed)
  self.count = self.count + elapsed % 1
  self.currentValue = self.startValue + (self.endValue - self.startValue) * handleEase(self.ease, math.max(0, math.min(self.count / self.duration, 1)));
  self.percent = (self.currentValue - self.startValue) / (self.endValue - self.startValue) * 100
  self.simplePercent = self.percent / 100
  if self.currentValue == self.endValue then
    if not self.onComplete.triggeredEnd and self.onComplete.onComplete and type(self.onComplete.onComplete) == 'function' then
      self.onComplete.triggeredEnd = true
      self.onComplete.onComplete();
    end
    if self.onFrame and type(self.onFrame) == 'function' then self.onFrame(); end
  else
    if self.onLerp and type(self.onLerp) == 'function' then self.onLerp(); end
  end
end


function handleEase(inputEase, t)
  inputEase = tostring(inputEase):lower():match('^%s*(.*%S)') or 'linear'
  local easeTable = {
    {ease = 'linear', value = t},
    {ease = 'quadin', value = t ^ 2},
    {ease = 'quadout', value = -t * (t - 2)},
    {ease = 'quadinout', value = t <= 0.5 and t * t * 2 or 1 - (1 - t) * t * 2},
    {ease = 'cubein', value = t ^ 3},
    {ease = 'cubeout', value = 1 + (1 - t) * t * t},
    {ease = 'cubeinout', value = t <= 0.5 and t * t * t * 4 or 1 + (1 - t) * t * t * 4},
    {ease = 'quartin', value = t ^ 4},
    {ease = 'quartout', value = 1 - (t - 1) * t * t * t},
    {ease = 'quartinout', value = t <= 0.5 and t * t * t * t * 8 or (1 - (t * 2 - 2) * t * t * t) / 2 + 0.5},
    {ease = 'quintin', value = t ^ 5},
    {ease = 'quintout', value = (t - 1) ^ 5 + 1},
    {ease = 'quintinout', value = t * 2 < 1 and (t ^ 5) / 2 or ((t - 2) * t * t * t * t + 2) / 2},
    {ease = 'smoothstepin', value = 2 * smoothStepInOut(t / 2)},
    {ease = 'smoothstepout', value = 2 * smoothStepInOut(t / 2 + 0.5) - 1},
    {ease = 'smoothstepinout', value = smoothStepInOut(t)},
    {ease = 'smootherstepin', value = 2 * smootherStepInOut(t / 2)},
    {ease = 'smootherstepout', value = 2 * smootherStepInOut(t / 2 + 0.5) - 1},
    {ease = 'smootherstepinout', value = smootherStepInOut(t)},
    {ease = 'sinein', value = -math.cos((math.pi / 2) * t) + 1},
    {ease = 'sineout', value = math.sin((math.pi / 2) * t)},
    {ease = 'sineinout', value = -math.cos(math.pi * t) / 2 + 0.5},
    {ease = 'bouncein', value = bounceIn(t)},
    {ease = 'bounceout', value = bounceOut(t)},
    {ease = 'bounceinout', value = bounceInOut(t)},
    {ease = 'circin', value = -(math.sqrt(1 - t * t) - 1)},
    {ease = 'circout', value = math.sqrt(1 - (t - 1) * (t - 1))},
    {ease = 'circinout', value = (t <= 0.5 and math.sqrt(1 - t * t * 4) - 1 / -2 or math.sqrt(1 - (t * 2 * 2) * (t * 2 - 2)) + 1) / 2},
    {ease = 'expoin', value = math.pow(2, 10 * (t - 1))},
    {ease = 'expoout', value = -math.pow(2, -10 * t) + 1},
    {ease = 'expoinout', value = t < 0.5 and math.pow(2, 10 * (t * 2 - 1)) / 2 or (-math.pow(2, -10 * (t * 2 - 1)) + 2) / 2},
    {ease = 'backin', value = t * t * (2.70158 * t - 1.70158)},
    {ease = 'backout', value = 1 - (1 - t) * t * (-2.70158 * t - 1.70158)},
    {ease = 'backinout', value = backInOut(t)},
    {ease = 'elasticin', value = -(math.pow(2, 10 * (t - 1)) * math.sin((t - (0.4 / (2 * math.pi) * math.asin(1))) * (2 * math.pi) / 0.4))},
    {ease = 'elasticout', value = math.pow(2, 10 * t) * math.sin((t - (0.4 / (2 * math.pi) * math.asin(1))) * (2 * math.pi) / 0.4) + 1},
    {ease = 'elasticinout', value = elasticInOut(t)},
  }
  for __, _ in ipairs(easeTable) do if _.ease == inputEase then return _.value end end
  return t
end


function smoothStepInOut(t) return t * t * (t * -2 + 3); end
function smootherStepInOut(t) return t * t * t * (t * (t * 6 - 15) + 10); end

function bounceIn(t)
  t = 1 - t
  if t < 1 / 2.75 then
    return 1 - 7.5625 * t * t
  elseif t < 2 / 2.75 then
    return 1 - (7.5625 * (t - (1.5 / 2.75)) * (t - (1.5 / 2.75)) + 0.75)
  elseif t < 2.5 / 2.75 then
    return 1 - (7.5625 * (t - (2.25 / 2.75)) * (t - (2.25 / 2.75)) + 0.9375)
  end
  return 1 - (7.5625 * (t - (2.625 / 2.75)) * (t - (2.625 / 2.75)) + 0.984375)
end

function bounceOut(t)
  t = 1 - t
  if t < 1 / 2.75 then
    return 7.5625 * t * t
  elseif t < 2 / 2.75 then
    return 7.5625 * (t - (1.5 / 2.75)) * (t - (1.5 / 2.75)) + 0.75
  elseif t < 2.5 / 2.75 then
    return 7.5625 * (t - (2.25 / 2.75)) * (t - (2.25 / 2.75)) + 0.9375
  end
  return 7.5625 * (t - (2.625 / 2.75)) * (t - (2.625 / 2.75)) + 0.984375
end

function bounceInOut(t)
  if t < 0.5 then
    t = 1 - t * 2
    if t < 1 / 2.75 then
      return (1 - 7.5625 * t * t) / 2
    elseif t < 2 / 2.75 then
      return (1 - (7.5625 * (t - (1.5 / 2.75)) * (t - (1.5 / 2.75)) + 0.75)) / 2
    elseif t < 2.5 / 2.75 then
      return (1 - (7.5625 * (t - (2.25 / 2.75)) * (t - (2.25 / 2.75)) + 0.9375)) / 2
    end
    return (1 - (7.5625 * (t - (2.625 / 2.75)) * (t - (2.625 / 2.75)) + 0.984375)) / 2
  end
  t = t * 2 - 1
  if t < 1 / 2.75 then
    return (7.5625 * t * t) / 2 + 0.5
  elseif t < 2 / 2.75 then
    return (7.5625 * (t - (1.5 / 2.75)) * (t - (1.5 / 2.75)) + 0.75) / 2 + 0.5
  elseif t < 2.5 / 2.75 then
    return (7.5625 * (t - (2.25 / 2.75)) * (t - (2.25 / 2.75)) + 0.9375) / 2 + 0.5
  end
  return (7.5625 * (t - (2.625 / 2.75)) * (t - (2.625 / 2.75)) + 0.984375) / 2 + 0.5
end

function backInOut(t)
  t = t * 2
  if t < 1 then return t * t * (2.70158 * t - 1.70158) / 2 end
  t = t - 1
  return (1 - (1 - t) * t * (-2.70158 * t - 1.70158)) / 2 + 0.5
end

function elasticInOut(t)
  if t < 0.5 then
    return -0.5 * (math.pow(2, 10 * (t - 0.5)) * math.sin((t - (0.4 / 4)) * (2 * math.pi) / 0.4));
  end
  return math.pow(2, -10 * (t - 0.5)) * math.sin((t - (0.4 / 4)) * (2 * math.pi) / 0.4) * 0.5 + 1;
end



return LerpUtils