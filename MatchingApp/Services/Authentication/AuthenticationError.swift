//
//  AuthenticationError.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/03.
//

import Foundation
import StoreKit
import Firebase
import FirebaseStorage

enum OtherError {
    case alreadyHasAccountError
    case hasNoAccountError
    case noMessageSendError
    case changeJpegError
    case invalidUrl
    case addPointError
    case verificationError
    case netWorkError
    case unexpectedError
}

enum AppError: Error {
    case auth(AuthErrorCode)
    case storage(Error)
    case firestore(Error)
    case storekit(Error)
    case other(OtherError)
    
    var errorMessage: String {
        switch self {
        case .auth(let authErrorCode):
            switch authErrorCode.code {
            case .weakPassword:
                return "入力されたパスワードが間違っています。もう一度確認してみてください。"
            case .invalidEmail:
                return "入力されたメールアドレスの形式が正しくありません。もう一度確認してみてください。"
            case .userDisabled:
                return "あなたのアカウントは無効化されています。サポートに連絡してください。"
            case .emailAlreadyInUse:
                return "このメールアドレスはすでに使用されています。別のメールアドレスを試してみてください。"
            case .userNotFound:
                return "このメールアドレスのアカウントは存在しません。登録がまだの場合は、新規登録をお願いします。"
            case .networkError:
                return "ネットワークに問題が発生しています。接続を確認してもう一度お試しください。"
            default:
                return "未知のエラーが発生しました。もう一度お試しください。"
            }
        case .storage(let error):
            if let storageError = error as? StorageError {
                switch storageError {
                case .unknown:
                    return "ネットワークに問題が発生しています。接続を確認してもう一度お試しください。"
                case .objectNotFound(let path):
                    return "指定されたオブジェクトが見つかりません。パス: \(path)"
                case .bucketNotFound(let bucket):
                    return "指定されたバケットが見つかりません。バケット名: \(bucket)"
                case .projectNotFound(let project):
                    return "指定されたプロジェクトが見つかりません。プロジェクト名: \(project)"
                case .quotaExceeded(let bucket):
                    return "ストレージの容量制限を超えました。バケット名: \(bucket)"
                case .unauthenticated:
                    return "認証されていません。ログインしてください。"
                case .unauthorized(let action, let path):
                    return "アクセス権限がありません。アクション: \(action), パス: \(path)"
                case .retryLimitExceeded:
                    return "ネットワークに問題が発生しています。接続を確認してもう一度お試しください。"
                case .nonMatchingChecksum:
                    return "データのチェックサムが一致しません。"
                case .downloadSizeExceeded(let size, let maxAllowedSize):
                    return "ダウンロードサイズが制限を超えました。サイズ: \(size), 最大許容サイズ: \(maxAllowedSize)"
                case .cancelled:
                    return "アクションがキャンセルされました。"
                case .invalidArgument(let argument):
                    return "無効な引数が指定されました。引数: \(argument)"
                case .internalError(let message):
                    return "内部エラーが発生しました。メッセージ: \(message)"
                }
            } else {
                return "ストレージエラー: \(error.localizedDescription)"
            }
        case .firestore(let error):
            if let error = error as? FirestoreErrorCode {
                switch error.code {
                case .cancelled:
                    return "データベース操作がキャンセルされました。"
                case .unknown:
                    return "未知のエラーが発生しました。もう一度お試しください。"
                case .invalidArgument:
                    return "無効な引数が指定されました。"
                case .deadlineExceeded:
                    return "ネットワークに問題が発生しています。接続を確認してもう一度お試しください。"
                case .notFound:
                    return "指定されたドキュメントは存在しません。"
                case .alreadyExists:
                    return "指定されたドキュメントはすでに存在します。"
                case .permissionDenied:
                    return "データベースへのアクセス権限がありません。"
                case .resourceExhausted:
                    return "リソースが不足しています。"
                case .failedPrecondition:
                    return "事前条件のチェックに失敗しました。"
                case .aborted:
                    return "操作が中断されました。"
                case .outOfRange:
                    return "指定された範囲が無効です。"
                case .unimplemented:
                    return "未実装の機能を呼び出そうとしました。"
                case .internal:
                    return "内部エラーが発生しました。"
                case .unavailable:
                    return "ネットワークに問題が発生しています。接続を確認してもう一度お試しください。"
                case .dataLoss:
                    return "データの損失が発生しました。"
                case .unauthenticated:
                    return "認証されていません。ログインしてください。"
                default:
                    return "データベースエラー: \(error.localizedDescription)"
                }
            } else {
                return "データベースエラー: \(error.localizedDescription)"
            }
        case .storekit(let error):
            if let error = error as? SKError {
                switch error.code {
                case .paymentCancelled:
                    return "購入がキャンセルされました。"
                case .paymentNotAllowed:
                    return "アプリ内で購入が許可されていません。お手数ですが設定アプリより、ご確認をお願いいたします。"
                default:
                    return "無効な購入が発生しました。心当たりがない場合は、お手数ですがサポートまでご連絡お願いいたします。"
                }
            } else {
                return "無効な購入が発生しました。心当たりがない場合は、お手数ですがサポートまでご連絡お願いいたします。"
            }
        case .other(let error):
            switch error {
            case .alreadyHasAccountError:
                return "このアカウントはすでに登録されています。"
            case .hasNoAccountError:
                return "このアドレスに紐づくアカウント情報は存在しません。"
            case .noMessageSendError:
                return "メッセージを入力してください。"
            case .changeJpegError:
                return "画像の処理に失敗しました。もう一度試すか、異なる画像を選択してください。"
            case .invalidUrl:
                return "提供された画像のURLを生成できませんでした。もう一度試すか、異なる画像を選択してください。"
            case .netWorkError:
                return "ネットワークに問題が発生しています。接続を確認してもう一度お試しください。"
            case .unexpectedError:
                return "未知のエラーが発生しました。もう一度お試しください。"
            case .addPointError:
                return "購入に成功しましたが、ポイントの付与に失敗しました。後ほどサポートよりポイントを付与させていただきますので、少々お待ちください。大変申し訳ありませんでした。"
            case .verificationError:
                return
                   "購入の検証に失敗しました。心当たりがない場合は、お手数ですがサポートまでご連絡お願いいたします。"
            }
        }
    }
}


