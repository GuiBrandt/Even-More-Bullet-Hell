=begin
	
	chipmunk.rb
	
	Arquivo com a importação do Chipmunk
	
=end

module Kernel
	extend DLLImport
    include DL
	
	typedef :float, 	:cpFloat
	typedef :pointer, 	:cpDataPointer
	typedef :pointer, 	:cpHashValue
	typedef :int, 		:cpCollisionID
	typedef :char, 		:cpBool
	typedef :pointer, 	:cpCollisionType
	typedef :pointer,	:cpGroup
	typedef :int,		:cpBitmask
	typedef :int,		:cpTimestamp
	typedef :pointer, 	:cpVect
	typedef :pointer, 	:cpTransform
	typedef :pointer,	:cpMat2x2
	typedef :pointer,	:cpContactPointSet
	
	CPVect = CStruct.create({
		x: SIZEOF_FLOAT,
		y: SIZEOF_FLOAT
	})
	
	CPTransform = CStruct.create({
		a: SIZEOF_FLOAT,
		b: SIZEOF_FLOAT,
		c: SIZEOF_FLOAT,
		d: SIZEOF_FLOAT,
		tx: SIZEOF_FLOAT,
		ty: SIZEOF_FLOAT
	})
	
	CPMat2x2 = CStruct.create({
		a: SIZEOF_FLOAT,
		b: SIZEOF_FLOAT,
		c: SIZEOF_FLOAT,
		d: SIZEOF_FLOAT
	})
	
	CPContactPointSet_point = CStruct.create({
		pointA: CPVect.size,
		pointB: CPVect.size,
		distance: SIZEOF_FLOAT
	})
	
	CPContactPointSet = CStruct.create({
		count: SIZEOF_INT,
		normal: CPVect.size,
		point0: CPContactPointSet_point.size,
		point1: CPContactPointSet_point.size
	})

	with_dll('chipmunk-7.0.1.dll') do
		import :cpMessage, :void 
		import :cpMomentForCircle, :cpFloat 
		import :cpAreaForCircle, :cpFloat 
		import :cpMomentForSegment, :cpFloat 
		import :cpAreaForSegment, :cpFloat 
		import :cpMomentForPoly, :cpFloat 
		import :cpAreaForPoly, :cpFloat 
		import :cpCentroidForPoly, :cpVect 
		import :cpMomentForBox, :cpFloat 
		import :cpMomentForBox2, :cpFloat 
		import :cpConvexHull, :int 
		import :cpCircleShapeSetRadius, :void 
		import :cpCircleShapeSetOffset, :void 
		import :cpSegmentShapeSetEndpoints, :void 
		import :cpSegmentShapeSetRadius, :void 
		import :cpPolyShapeSetVerts, :void 
		import :cpPolyShapeSetVertsRaw, :void 
		import :cpPolyShapeSetRadius, :void 
		import :cpArbiterGetRestitution, :cpFloat 
		import :cpArbiterSetRestitution, :void 
		import :cpArbiterGetFriction, :cpFloat 
		import :cpArbiterSetFriction, :void 
		import :cpArbiterGetSurfaceVelocity, :cpVect 
		import :cpArbiterSetSurfaceVelocity, :void 
		import :cpArbiterGetUserData, :cpDataPointer 
		import :cpArbiterSetUserData, :void 
		import :cpArbiterTotalImpulse, :cpVect 
		import :cpArbiterTotalKE, :cpFloat 
		import :cpArbiterIgnore, :cpBool 
		import :cpArbiterGetShapes, :void 
		import :cpArbiterGetBodies, :void 
		import :cpArbiterGetContactPointSet, :cpContactPointSet 
		import :cpArbiterSetContactPointSet, :void 
		import :cpArbiterIsFirstContact, :cpBool 
		import :cpArbiterIsRemoval, :cpBool 
		import :cpArbiterGetCount, :int 
		import :cpArbiterGetNormal, :cpVect 
		import :cpArbiterGetPointA, :cpVect 
		import :cpArbiterGetPointB, :cpVect 
		import :cpArbiterGetDepth, :cpFloat 
		import :cpArbiterCallWildcardBeginA, :cpBool 
		import :cpArbiterCallWildcardBeginB, :cpBool 
		import :cpArbiterCallWildcardPreSolveA, :cpBool 
		import :cpArbiterCallWildcardPreSolveB, :cpBool 
		import :cpArbiterCallWildcardPostSolveA, :void 
		import :cpArbiterCallWildcardPostSolveB, :void 
		import :cpArbiterCallWildcardSeparateA, :void 
		import :cpArbiterCallWildcardSeparateB, :void 
		import :cpBodyDestroy, :void 
		import :cpBodyFree, :void 
		import :cpBodyActivate, :void 
		import :cpBodyActivateStatic, :void 
		import :cpBodySleep, :void 
		import :cpBodySleepWithGroup, :void 
		import :cpBodyIsSleeping, :cpBool 
		import :cpBodyGetType, :cpBodyType 
		import :cpBodySetType, :void 
		import :cpBodyGetMass, :cpFloat 
		import :cpBodySetMass, :void 
		import :cpBodyGetMoment, :cpFloat 
		import :cpBodySetMoment, :void 
		import :cpBodyGetPosition, :cpVect 
		import :cpBodySetPosition, :void 
		import :cpBodyGetCenterOfGravity, :cpVect 
		import :cpBodySetCenterOfGravity, :void 
		import :cpBodyGetVelocity, :cpVect 
		import :cpBodySetVelocity, :void 
		import :cpBodyGetForce, :cpVect 
		import :cpBodySetForce, :void 
		import :cpBodyGetAngle, :cpFloat 
		import :cpBodySetAngle, :void 
		import :cpBodyGetAngularVelocity, :cpFloat 
		import :cpBodySetAngularVelocity, :void 
		import :cpBodyGetTorque, :cpFloat 
		import :cpBodySetTorque, :void 
		import :cpBodyGetRotation, :cpVect 
		import :cpBodyGetUserData, :cpDataPointer 
		import :cpBodySetUserData, :void 
		import :cpBodySetVelocityUpdateFunc, :void 
		import :cpBodySetPositionUpdateFunc, :void 
		import :cpBodyUpdateVelocity, :void 
		import :cpBodyUpdatePosition, :void 
		import :cpBodyLocalToWorld, :cpVect 
		import :cpBodyWorldToLocal, :cpVect 
		import :cpBodyApplyForceAtWorldPoint, :void 
		import :cpBodyApplyForceAtLocalPoint, :void 
		import :cpBodyApplyImpulseAtWorldPoint, :void 
		import :cpBodyApplyImpulseAtLocalPoint, :void 
		import :cpBodyGetVelocityAtWorldPoint, :cpVect 
		import :cpBodyGetVelocityAtLocalPoint, :cpVect 
		import :cpBodyKineticEnergy, :cpFloat 
		import :cpBodyEachShape, :void 
		import :cpBodyEachConstraint, :void 
		import :cpBodyEachArbiter, :void 
		import :cpConstraintDestroy, :void 
		import :cpConstraintFree, :void 
		import :cpConstraintGetMaxForce, :cpFloat 
		import :cpConstraintSetMaxForce, :void 
		import :cpConstraintGetErrorBias, :cpFloat 
		import :cpConstraintSetErrorBias, :void 
		import :cpConstraintGetMaxBias, :cpFloat 
		import :cpConstraintSetMaxBias, :void 
		import :cpConstraintGetCollideBodies, :cpBool 
		import :cpConstraintSetCollideBodies, :void 
		import :cpConstraintGetPreSolveFunc, :pointer
		import :cpConstraintSetPreSolveFunc, :void 
		import :cpConstraintGetPostSolveFunc, :pointer
		import :cpConstraintSetPostSolveFunc, :void 
		import :cpConstraintGetUserData, :cpDataPointer 
		import :cpConstraintSetUserData, :void 
		import :cpConstraintGetImpulse, :cpFloat 
		import :cpConstraintIsDampedRotarySpring, :cpBool 
		import :cpDampedRotarySpringGetRestAngle, :cpFloat 
		import :cpDampedRotarySpringSetRestAngle, :void 
		import :cpDampedRotarySpringGetStiffness, :cpFloat 
		import :cpDampedRotarySpringSetStiffness, :void 
		import :cpDampedRotarySpringGetDamping, :cpFloat 
		import :cpDampedRotarySpringSetDamping, :void 
		import :cpDampedRotarySpringGetSpringTorqueFunc, :pointer
		import :cpDampedRotarySpringSetSpringTorqueFunc, :void 
		import :cpConstraintIsDampedSpring, :cpBool 
		import :cpDampedSpringGetAnchorA, :cpVect 
		import :cpDampedSpringSetAnchorA, :void 
		import :cpDampedSpringGetAnchorB, :cpVect 
		import :cpDampedSpringSetAnchorB, :void 
		import :cpDampedSpringGetRestLength, :cpFloat 
		import :cpDampedSpringSetRestLength, :void 
		import :cpDampedSpringGetStiffness, :cpFloat 
		import :cpDampedSpringSetStiffness, :void 
		import :cpDampedSpringGetDamping, :cpFloat 
		import :cpDampedSpringSetDamping, :void 
		import :cpDampedSpringGetSpringForceFunc, :pointer
		import :cpDampedSpringSetSpringForceFunc, :void 
		import :cpConstraintIsGearJoint, :cpBool 
		import :cpGearJointGetPhase, :cpFloat 
		import :cpGearJointSetPhase, :void 
		import :cpGearJointGetRatio, :cpFloat 
		import :cpGearJointSetRatio, :void 
		import :cpConstraintIsGrooveJoint, :cpBool 
		import :cpGrooveJointGetGrooveA, :cpVect 
		import :cpGrooveJointSetGrooveA, :void 
		import :cpGrooveJointGetGrooveB, :cpVect 
		import :cpGrooveJointSetGrooveB, :void 
		import :cpGrooveJointGetAnchorB, :cpVect 
		import :cpGrooveJointSetAnchorB, :void
		import :cpConstraintIsPinJoint, :cpBool 
		import :cpPinJointGetAnchorA, :cpVect 
		import :cpPinJointSetAnchorA, :void 
		import :cpPinJointGetAnchorB, :cpVect 
		import :cpPinJointSetAnchorB, :void 
		import :cpPinJointGetDist, :cpFloat 
		import :cpPinJointSetDist, :void 
		import :cpConstraintIsPivotJoint, :cpBool 
		import :cpPivotJointGetAnchorA, :cpVect 
		import :cpPivotJointSetAnchorA, :void 
		import :cpPivotJointGetAnchorB, :cpVect 
		import :cpPivotJointSetAnchorB, :void 
		import :cpPolylineFree, :void 
		import :cpPolylineIsClosed, :cpBool 
		import :cpPolylineSimplifyCurves, :pointer
		import :cpPolylineSimplifyVertexes, :pointer
		import :cpPolylineToConvexHull, :pointer
		import :cpPolylineSetAlloc, :pointer
		import :cpPolylineSetInit, :pointer
		import :cpPolylineSetNew, :pointer
		import :cpPolylineSetDestroy, :void 
		import :cpPolylineSetCollectSegment, :void 
		import :cpPolylineConvexDecomposition, :pointer
		import :cpPolyShapeGetCount, :int 
		import :cpPolyShapeGetVert, :cpVect 
		import :cpPolyShapeGetRadius, :cpFloat 
		import :cpConstraintIsRatchetJoint, :cpBool 
		import :cpRatchetJointGetAngle, :cpFloat 
		import :cpRatchetJointSetAngle, :void 
		import :cpRatchetJointGetPhase, :cpFloat 
		import :cpRatchetJointSetPhase, :void 
		import :cpRatchetJointGetRatchet, :cpFloat 
		import :cpRatchetJointSetRatchet, :void 
		import :cpConstraintIsRotaryLimitJoint, :cpBool 
		import :cpRotaryLimitJointGetMin, :cpFloat 
		import :cpRotaryLimitJointSetMin, :void 
		import :cpRotaryLimitJointGetMax, :cpFloat 
		import :cpRotaryLimitJointSetMax, :void 
		import :cpShapeDestroy, :void 
		import :cpShapeFree, :void 
		import :cpShapeCacheBB, :cpBB 
		import :cpShapeUpdate, :cpBB 
		import :cpShapePointQuery, :cpFloat 
		import :cpShapeSegmentQuery, :cpBool 
		import :cpShapesCollide, :cpContactPointSet 
		import :cpShapeSetBody, :void 
		import :cpShapeSetMass, :void 
		import :cpShapeGetDensity, :cpFloat 
		import :cpShapeSetDensity, :void 
		import :cpShapeGetMoment, :cpFloat 
		import :cpShapeGetArea, :cpFloat 
		import :cpShapeGetCenterOfGravity, :cpVect 
		import :cpShapeGetBB, :cpBB 
		import :cpShapeGetSensor, :cpBool 
		import :cpShapeSetSensor, :void 
		import :cpShapeGetElasticity, :cpFloat 
		import :cpShapeSetElasticity, :void 
		import :cpShapeGetFriction, :cpFloat 
		import :cpShapeSetFriction, :void 
		import :cpShapeGetSurfaceVelocity, :cpVect 
		import :cpShapeSetSurfaceVelocity, :void 
		import :cpShapeGetUserData, :cpDataPointer 
		import :cpShapeSetUserData, :void 
		import :cpShapeGetCollisionType, :cpCollisionType 
		import :cpShapeSetCollisionType, :void 
		import :cpShapeGetFilter, :cpShapeFilter 
		import :cpShapeSetFilter, :void 
		import :cpCircleShapeGetOffset, :cpVect 
		import :cpCircleShapeGetRadius, :cpFloat 
		import :cpSegmentShapeSetNeighbors, :void 
		import :cpSegmentShapeGetA, :cpVect 
		import :cpSegmentShapeGetB, :cpVect 
		import :cpSegmentShapeGetNormal, :cpVect 
		import :cpSegmentShapeGetRadius, :cpFloat 
		import :cpConstraintIsSimpleMotor, :cpBool 
		import :cpSimpleMotorGetRate, :cpFloat 
		import :cpSimpleMotorSetRate, :void 
		import :cpConstraintIsSlideJoint, :cpBool 
		import :cpSlideJointGetAnchorA, :cpVect 
		import :cpSlideJointSetAnchorA, :void 
		import :cpSlideJointGetAnchorB, :cpVect 
		import :cpSlideJointSetAnchorB, :void 
		import :cpSlideJointGetMin, :cpFloat 
		import :cpSlideJointSetMin, :void 
		import :cpSlideJointGetMax, :cpFloat 
		import :cpSlideJointSetMax, :void 
		import :cpSpaceDestroy, :void 
		import :cpSpaceFree, :void 
		import :cpSpaceGetIterations, :int 
		import :cpSpaceSetIterations, :void 
		import :cpSpaceGetGravity, :cpVect 
		import :cpSpaceSetGravity, :void 
		import :cpSpaceGetDamping, :cpFloat 
		import :cpSpaceSetDamping, :void 
		import :cpSpaceGetIdleSpeedThreshold, :cpFloat 
		import :cpSpaceSetIdleSpeedThreshold, :void 
		import :cpSpaceGetSleepTimeThreshold, :cpFloat 
		import :cpSpaceSetSleepTimeThreshold, :void 
		import :cpSpaceGetCollisionSlop, :cpFloat 
		import :cpSpaceSetCollisionSlop, :void 
		import :cpSpaceGetCollisionBias, :cpFloat 
		import :cpSpaceSetCollisionBias, :void 
		import :cpSpaceGetCollisionPersistence, :cpTimestamp 
		import :cpSpaceSetCollisionPersistence, :void 
		import :cpSpaceGetUserData, :cpDataPointer 
		import :cpSpaceSetUserData, :void 
		import :cpSpaceGetCurrentTimeStep, :cpFloat 
		import :cpSpaceIsLocked, :cpBool 
		import :cpSpaceAddDefaultCollisionHandler, :pointer
		import :cpSpaceAddCollisionHandler, :pointer
		import :cpSpaceAddWildcardHandler, :pointer
		import :cpSpaceRemoveShape, :void 
		import :cpSpaceRemoveBody, :void 
		import :cpSpaceRemoveConstraint, :void 
		import :cpSpaceContainsShape, :cpBool 
		import :cpSpaceContainsBody, :cpBool 
		import :cpSpaceContainsConstraint, :cpBool 
		import :cpSpaceAddPostStepCallback, :cpBool 
		import :cpSpacePointQuery, :void 
		import :cpSpacePointQueryNearest, :pointer
		import :cpSpaceSegmentQuery, :void 
		import :cpSpaceSegmentQueryFirst, :pointer
		import :cpSpaceBBQuery, :void 
		import :cpSpaceShapeQuery, :cpBool 
		import :cpSpaceEachBody, :void 
		import :cpSpaceEachShape, :void 
		import :cpSpaceEachConstraint, :void 
		import :cpSpaceReindexStatic, :void 
		import :cpSpaceReindexShape, :void 
		import :cpSpaceReindexShapesForBody, :void 
		import :cpSpaceUseSpatialHash, :void 
		import :cpSpaceStep, :void 
		import :cpSpaceDebugDraw, :void 
		import :cpSpaceHashResize, :void 
		import :cpBBTreeOptimize, :void 
		import :cpBBTreeSetVelocityFunc, :void
	end
end