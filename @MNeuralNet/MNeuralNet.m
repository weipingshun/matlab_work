function a = MNeuralNet(layerNum, layerUnitCounts, weights)
    a.layerNum = layerNum;
    a.layerUnitCounts = layerUnitCounts;
    a.weights = weights;
    a = class(a, 'MNeuralNet');