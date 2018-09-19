//
//  CameraService.swift
//  Core
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import AVFoundation

public enum CameraAuthorizationStatus: Int {
    case notDetermined
    case restricted
    case denied
    case authorized
    
    fileprivate init(avauthorizationStatus: AVAuthorizationStatus) {
        switch  avauthorizationStatus {
        case .notDetermined: self = .notDetermined
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .authorized: self = .authorized
        }
    }
}

public protocol CameraService: AutoMockable {
    var cameraAuthorizationStatus: CameraAuthorizationStatus { get }
}

public final class CameraServiceImpl: CameraService {
    private let authorizationStatus: AVAuthorizationStatus
    
    public init(
        authorizationStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    ) {
        self.authorizationStatus = authorizationStatus
    }
    
    public var cameraAuthorizationStatus: CameraAuthorizationStatus {
        return CameraAuthorizationStatus(avauthorizationStatus: authorizationStatus)
    }
}
