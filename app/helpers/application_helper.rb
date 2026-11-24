module ApplicationHelper
  def default_meta_tags
    {
      site: "キミが幹事だ！",
      reverse: true,
      separator: "|",
      description: "参加者の出発駅から最も遠い2人の中間駅と周辺のお店候補をかんたんに提案・共有できるWebアプリ",
      keywords: "中間駅, 集合場所, 飲み会, 幹事, 路線, 飲食店",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image"
      }
    }
  end
end
