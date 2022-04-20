#!/usr/bin/env python3

import cv2
import depthai as dai








#################
 
def gsuStitch(imgs):
    stitchy=cv2.Stitcher.create()
    (dummy,output)=stitchy.stitch(imgs)
    
    if dummy != cv2.STITCHER_OK:
    # checking if the stitching procedure is successful
    # .stitch() function returns a true value if stitching is
    # done successfully
        print("stitching ain't successful")
    else:
        print('Your Panorama is ready!!!')
    
    # final output
    cv2.imshow("result",output)
    cv2.imwrite("p7panorama.jpg", output)

#################
# Create pipeline
pipeline = dai.Pipeline()

# Define source and output
camRgb = pipeline.create(dai.node.ColorCamera)
xoutRgb = pipeline.create(dai.node.XLinkOut)

xoutRgb.setStreamName("rgb")

# Properties
#camRgb.setPreviewSize(300, 300)
camRgb.setInterleaved(False)
camRgb.setColorOrder(dai.ColorCameraProperties.ColorOrder.RGB)

# Linking
camRgb.preview.link(xoutRgb.input)

# Connect to device and start pipeline
imgs = []
with dai.Device(pipeline) as device:
    print('Connected cameras: ', device.getConnectedCameras())
    # Print out usb speed
    print('Usb speed: ', device.getUsbSpeed().name)

    # Output queue will be used to get the rgb frames from the output defined above
    qRgb = device.getOutputQueue(name="rgb", maxSize=4, blocking=False)

    while True:
        inRgb = qRgb.get()  # blocking call, will wait until a new data has arrived

        frame = inRgb.getCvFrame()
        # Retrieve 'bgr' (opencv format) frame
        cv2.imshow("rgb", frame)
        waitkey = cv2.waitKey(1)
        if waitkey == ord(' '):
            print('taking a picture')
            print( frame.shape )#300,300,3
            #name = "image_"+str(img_counter)+'.png'
            #print(name)
            #cv2.imwrite(name, frame)
            
            imgs.append(frame)
            if len(imgs) == 14:
                gsuStitch(imgs)
                imgs = []
        elif waitkey == ord('q'):
            break
