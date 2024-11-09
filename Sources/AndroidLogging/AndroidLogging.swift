//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Logging API open source project
//
// Copyright (c) 2018-2019 Apple Inc. and the Swift Logging API project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Logging API project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Android
import CAndroidLogging
import Logging

extension Logger.Level {
  var androidLogPriority: android_LogPriority {
    switch self {
    case .trace:
      return ANDROID_LOG_VERBOSE
    case .debug:
      return ANDROID_LOG_DEBUG
    case .info:
      fallthrough
    case .notice:
      return ANDROID_LOG_INFO
    case .warning:
      return ANDROID_LOG_WARN
    case .error:
      return ANDROID_LOG_ERROR
    case .critical:
      return ANDROID_LOG_FATAL
    }
  }
}

public struct AndroidLogHandler: LogHandler {
  public var logLevel: Logger.Level = .info
  public var metadataProvider: Logger.MetadataProvider?

  public enum TagSource {
    case label
    case source
  }

  private let label: String
  private let tagSource: TagSource

  public static func taggedByLabel(
    label: String,
    metadataProvider: Logger.MetadataProvider?
  ) -> AndroidLogHandler {
    AndroidLogHandler(label: label, metadataProvider: metadataProvider, tagSource: .label)
  }

  public static func taggedBySource(
    label: String,
    metadataProvider: Logger.MetadataProvider?
  ) -> AndroidLogHandler {
    AndroidLogHandler(label: label, metadataProvider: metadataProvider, tagSource: .source)
  }

  public init(
    label: String,
    metadataProvider: Logger.MetadataProvider? = nil,
    tagSource: TagSource = .label
  ) {
    self.label = label
    self.metadataProvider = metadataProvider
    self.tagSource = tagSource
  }

  public func log(
    level: Logger.Level,
    message: Logger.Message,
    metadata: Logger.Metadata?,
    source: String,
    file: String,
    function: String,
    line: UInt
  ) {
    var text = "\(prettyMetadata.map { "\($0) " } ?? "")"

    if tagSource == .label {
      text += "[\(source)]"
    }

    text += " \(message)"

    _ = __android_log_write(
      CInt(level.androidLogPriority.rawValue),
      tagSource == .label ? label : source,
      text
    )
  }

  private var prettyMetadata: String?
  public var metadata = Logger.Metadata() {
    didSet {
      prettyMetadata = prettify(metadata)
    }
  }

  private func prettify(_ metadata: Logger.Metadata) -> String? {
    if metadata.isEmpty {
      return nil
    } else {
      return metadata.lazy.sorted(by: { $0.key < $1.key }).map { "\($0)=\($1)" }
        .joined(separator: " ")
    }
  }

  public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
    get {
      metadata[metadataKey]
    }
    set(newValue) {
      metadata[metadataKey] = newValue
    }
  }
}
