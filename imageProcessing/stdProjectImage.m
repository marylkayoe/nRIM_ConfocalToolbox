function stdProjected = stdProjectImage(imageStack)
stdProjected = std(double(imageStack), [], 3);
end