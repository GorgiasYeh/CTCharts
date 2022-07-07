
import UIKit

/// Interactable line graph. The difference between this and `CTLineGraphLayer` is that this has the
/// ability to respond to touches
class CTLinePlotView: CTGradientPlotView<CTLineLayer> {

    override func resetLayers() {
        let graphRect = graphBounds()
        let offsets = computeLineOffsets()
        resolveNumberOfLayers()
        dataSeries.enumerated().forEach { index, series in
            let layer = seriesLayers[index]
            layer.dataPoints = series.dataPoints
            layer.offset = offsets[index]
            layer.startColor = series.gradientStartColor ?? tintColor
            layer.endColor = series.gradientEndColor ?? tintColor
            layer.lineWidth = series.size
            layer.setPlotBounds(rect: graphRect)
            layer.frame = bounds
        }
        super.resetLayers()
    }

    // Adjust the x coordinates of the data series so that two identical lines are slightly offset, so as to be distinguishable.
    private func computeLineOffsets() -> [CGSize] {
        guard !dataSeries.isEmpty else { return [] }
        let spacing: CGFloat = 1.0
        let totalWidth = spacing * CGFloat(dataSeries.count - 1)
        let startOffset = -totalWidth / 2
        var offsets = [CGSize]()
        for index in 0..<dataSeries.count {
            offsets.append(CGSize(width: startOffset + spacing * CGFloat(index), height: 0))
        }
        return offsets
    }

    private func resolveNumberOfLayers() {
        while seriesLayers.count < dataSeries.count {
            let newLayer = CTLineLayer()
            seriesLayers.append(newLayer)
            layer.addSublayer(newLayer)
        }
        while seriesLayers.count > dataSeries.count {
            let oldLayer = seriesLayers.removeLast()
            oldLayer.removeFromSuperlayer()
        }
    }
}
