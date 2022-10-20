local math_utils = {}

function math_utils.degtorad(degrees)
    return degrees * math.pi/180
end

function math_utils.radtodeg(radians)
    return radians * 180/math.pi
end

return math_utils