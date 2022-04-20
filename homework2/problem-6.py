import cv2
import depthai as dai
import numpy as np

def myIntegralImage(img):
  
  temp = np.pad(img, 1, 'constant', constant_values=0).astype(np.longlong)
  #print(img.dtype)
  #print(temp.dtype)
  for j in range(1,temp.shape[0]-1):
    for i in range(1,temp.shape[1]-1):
      temp[j,i] = temp[j-1,i]+temp[j,i-1]+temp[j,i]-temp[j-1,i-1]


  temp = (temp-np.min(temp))/(np.max(temp-np.min(temp)))*255
  temp = temp.astype(img.dtype) 
  return temp


# Create pipeline
pipeline = dai.Pipeline()

# Define sources and outputs
monoLeft = pipeline.create(dai.node.MonoCamera)
monoRight = pipeline.create(dai.node.MonoCamera)
xoutLeft = pipeline.create(dai.node.XLinkOut)
xoutRight = pipeline.create(dai.node.XLinkOut)

xoutLeft.setStreamName('left')
xoutRight.setStreamName('right')

# Properties
monoLeft.setBoardSocket(dai.CameraBoardSocket.LEFT)
monoLeft.setResolution(dai.MonoCameraProperties.SensorResolution.THE_480_P)
monoRight.setBoardSocket(dai.CameraBoardSocket.RIGHT)
monoRight.setResolution(dai.MonoCameraProperties.SensorResolution.THE_720_P)

# Linking
monoRight.out.link(xoutRight.input)
monoLeft.out.link(xoutLeft.input)

# Connect to device and start pipeline
with dai.Device(pipeline) as device:

    # Output queues will be used to get the grayscale frames from the outputs defined above
    qLeft = device.getOutputQueue(name="left", maxSize=4, blocking=False)
    qRight = device.getOutputQueue(name="right", maxSize=4, blocking=False)

    while True:
        # Instead of get (blocking), we use tryGet (non-blocking) which will return the available data or None otherwise
        inLeft = qLeft.tryGet()
        inRight = qRight.tryGet()
        #print(inLeft.getCvFrame().shape)
        if inLeft is not None:
            iL = inLeft.getCvFrame()
            mii = myIntegralImage(iL)
            #print(mii,np.sum(iL))
            #assert np.sum(iL) == mii[-2,-2]
            #print(iL.shape)
            cv2.imshow("left", iL)
            cv2.imshow("integral image", myIntegralImage(iL))

        #if inRight is not None:
            #cv2.imshow("right", inRight.getCvFrame())

        if cv2.waitKey(1) == ord('q'):
            break   